package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuildIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.MemoryTransformer;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.RegisterTransformer;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventUser;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.core.utils.RegWriter;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.specification.AbstractAssert;
import com.google.common.collect.Lists;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.program.ScopeHierarchy.ScopeHierarchyForVulkan;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class ProgramBuilderSpv {

    private final HelperTags helper = new HelperTags();
    private final Map<String, Type> types = new HashMap<>();
    private final Map<String, Type> pointedTypes = new HashMap<>();
    private final Map<String, Expression> expressions = new HashMap<>();
    private final Map<String, Function> forwardFunctions = new HashMap<>();
    private final Map<Label, Map<Register, String>> phiDefinitions = new HashMap<>();
    private final Map<Label, Event> phiBlocks = new HashMap<>();
    private final Map<String, Label> labels = new HashMap<>();
    private final Deque<Label> blocks = new ArrayDeque<>();
    private final Map<String, List<String>> decorations = new HashMap<>();
    private final Set<String> specConstants = new HashSet<>();
    private final Program program;
    private List<Integer> threadGrid = null;

    private String entryPointId;
    protected Function currentFunction;
    private int nextFunctionId = 0;

    public ProgramBuilderSpv() {
        this.program = new Program(new Memory(), Program.SourceLanguage.SPV);
    }

    public Program build() {
        validateBeforeBuild();
        // TODO: append Phi Definitions
        Function entry = getEntryPointFunction();
        for (int z = 0; z < threadGrid.get(2); z++) {
            for (int y = 0; y < threadGrid.get(1); y++) {
                for (int x = 0; x < threadGrid.get(0); x++) {
                    program.addThread(createThreadFromFunction(entry, x, y, z));
                }
            }
        }
        // TODO: Cleanup old function and its thread-local variables
        return program;
    }

    public void setEntryPointId(String id) {
        if (entryPointId != null) {
            throw new ParsingException("Multiple entry points are not supported");
        }
        entryPointId = id;
    }

    public void setAssert(AbstractAssert ast) {
        program.setSpecification(ast);
    }

    public void setAssertFilter(AbstractAssert ast) {
        ast.setType(AbstractAssert.ASSERT_TYPE_FORALL);
        program.setFilterSpecification(ast);
    }

    public void startFunctionDefinition(String id, FunctionType type, List<String> args) {
        if (currentFunction != null) {
            throw new ParsingException("Attempt to define function '%s' " +
                    "inside a definition of another function '%s'",
                    id, currentFunction.getName());
        }
        Function function = forwardFunctions.remove(id);
        if (function != null) {
            checkFunctionType(id, function, type);
            for (int i = 0; i < args.size(); i++) {
                function.getParameterRegisters().get(i).setName(args.get(i));
            }
        } else {
            function = new Function(id, type, args, nextFunctionId++, null);
        }
        program.addFunction(function);
        addExpression(id, function);
        for (Register register : function.getParameterRegisters()) {
            addExpression(register.getName(), register);
        }
        currentFunction = function;
    }

    public void endFunctionDefinition() {
        if (currentFunction == null) {
            throw new ParsingException("Illegal attempt to exit a function definition");
        }
        currentFunction = null;
    }

    public Function getCalledFunction(String id, FunctionType type) {
        Expression expression = expressions.get(id);
        if (expression instanceof Function function) {
            return checkFunctionType(id, function, type);
        }
        if (expression == null) {
            Function function = forwardFunctions.computeIfAbsent(id, k -> {
                List<String> args = IntStream.range(0, type.getParameterTypes().size())
                        .boxed().map(i -> "param_" + i)
                        .toList();
                return new Function(id, type, args, nextFunctionId++, null);
            });
            return checkFunctionType(id, function, type);
        }
        throw new ParsingException("Unexpected type of expression '%s', " +
                "expected a function but received '%s'", id, expression.getType());
    }

    private Function checkFunctionType(String id, Function function, Type type) {
        if (function.getFunctionType().equals(type)) {
            return function;
        }
        throw new ParsingException("Illegal call of function '%s', " +
                "function type doesn't match the function definition", id);
    }

    public void startBlock(Label label) {
        if (phiBlocks.containsKey(label)) {
            throw new ParsingException("Attempt to redefine label '%s'", label.getName());
        }
        blocks.push(label);
    }

    public void endBlock(Event event) {
        if (blocks.isEmpty()) {
            throw new ParsingException("Attempt to exit block while not in a block definition");
        }
        phiBlocks.put(blocks.pop(), event);
    }

    public Event addEvent(Event event) {
        if (currentFunction == null) {
            throw new ParsingException("Attempt to add an event outside a function definition");
        }
        if (blocks.isEmpty()) {
            throw new ParsingException("Attempt to add an event outside a control flow block");
        }
        if (event instanceof RegWriter regWriter) {
            Register register = regWriter.getResultRegister();
            addExpression(register.getName(), register);
        }
        currentFunction.append(event);
        return event;
    }

    public MemoryObject allocateMemory(int bytes) {
        return program.getMemory().allocate(bytes, true);
    }

    public Type getType(String name) {
        Type type = types.get(name);
        if (type == null) {
            throw new ParsingException("Reference to undefined type '%s'", name);
        }
        return type;
    }

    public Type addType(String name, Type type) {
        if (types.containsKey(name) || expressions.containsKey(name)) {
            throw new ParsingException("Duplicated definition '%s'", name);
        }
        types.put(name, type);
        return type;
    }

    public Type getPointedType(String name) {
        Type type = pointedTypes.get(name);
        if (type == null) {
            throw new ParsingException("Reference to undefined pointer type '%s'", name);
        }
        return type;
    }

    public Type addPointedType(String name, Type type) {
        if (pointedTypes.containsKey(name)) {
            throw new ParsingException("Duplicated pointer type definition '%s'", name);
        }
        pointedTypes.put(name, type);
        return type;
    }

    public Expression getExpression(String name) {
        Expression expression = expressions.get(name);
        if (expression == null) {
            throw new ParsingException("Reference to undefined expression '%s'", name);
        }
        return expression;
    }

    public Expression addExpression(String name, Expression value) {
        if (types.containsKey(name) || expressions.containsKey(name)) {
            throw new ParsingException("Duplicated definition '%s'", name);
        }
        expressions.put(name, value);
        return value;
    }

    // TODO: Check during decoration if a constant is Spec
    public boolean isSpecConstant(String id) {
        return specConstants.contains(id);
    }

    public Expression addConstant(String id, Expression expression) {
        return addExpression(id, expression);
    }

    public Expression addSpecConstant(String id, Expression expression) {
        specConstants.add(id);
        return addExpression(id, expression);
    }

    public Register getRegister(String id) {
        return getCurrentFunctionOrThrowError().getRegister(id);
    }

    public Register addRegister(String id, String typeId) {
        return getCurrentFunctionOrThrowError().newRegister(id, getType(typeId));
    }

    public Label getOrCreateLabel(String id){
        Label label = labels.computeIfAbsent(id, EventFactory::newLabel);
        if (label.getFunction() == null) {
            label.setFunction(getCurrentFunctionOrThrowError());
        }
        return label;
    }

    public void addDecoration(String id, String decoration) {
        decorations.computeIfAbsent(id, k -> new ArrayList<>()).add(decoration);
    }

    public String getScope(String id) {
        return helper.visitScope(id, getExpression(id));
    }

    public Set<String> getSemantics(String id) {
        return helper.visitIdMemorySemantics(id, getExpression(id));
    }

    private Function getCurrentFunctionOrThrowError() {
        if (currentFunction != null) {
            return currentFunction;
        }
        throw new ParsingException("Attempt to reference current function " +
                "outside of a function definition");
    }

    private Thread createThreadFromFunction(Function function, int x, int y, int z) {
        int tid = x + y * threadGrid.get(0) + z * threadGrid.get(0) * threadGrid.get(1);
        ScopeHierarchy scope = ScopeHierarchyForVulkan(0, z, y);
        Thread thread = createThread(tid, scope, function);
        copyEvents(tid, thread, function);
        BuildIn decoration = new BuildIn(x, y, z);
        Memory memory = program.getMemory();

        // Create thread-local variables
        ExprTransformer transformer = new MemoryTransformer(tid, memory, decoration, decorations);
        thread.getEvents(RegReader.class).forEach(reader -> reader.transformExpressions(transformer));
        return thread;
    }

    private Thread createThread(int id, ScopeHierarchy scope, Function function) {
        String name = function.getName();
        FunctionType type = function.getFunctionType();
        List<String> args = Lists.transform(function.getParameterRegisters(), Register::getName);
        ThreadStart start = EventFactory.newThreadStart(null);
        Thread thread = new Thread(name, type, args, id, start, scope, Set.of());
        thread.copyDummyCountFrom(function);
        return thread;
    }

    private void copyEvents(int id, Thread thread, Function function) {
        // ------------------- Copy registers from target function into new thread -------------------

        Map<Register, Register> mapping = function.getRegisters().stream()
                .collect(Collectors.toMap(r -> r, r -> thread.getOrNewRegister(r.getName(), r.getType())));
        ExprTransformer transformer = new RegisterTransformer(mapping);

        // ------------------- Copy, update, and append the function body to the thread -------------------
        List<Event> body = new ArrayList<>();
        Map<Event, Event> copyMap = new HashMap<>();
        function.getEvents().forEach(e -> body.add(copyMap.computeIfAbsent(e, Event::getCopy)));
        for (Event copy : body) {
            if (copy instanceof EventUser user) {
                user.updateReferences(copyMap);
            }
            if (copy instanceof RegReader reader) {
                reader.transformExpressions(transformer);
            }
            if (copy instanceof RegWriter regWriter) {
                regWriter.setResultRegister(mapping.get(regWriter.getResultRegister()));
            }
        }
        thread.getEntry().insertAfter(body);

        // ------------------- Add end & return label -------------------
        final Label threadReturnLabel = EventFactory.newLabel("RETURN_OF_T" + id);
        final Label threadEnd = EventFactory.newLabel("END_OF_T" + id);
        thread.append(threadReturnLabel);
        thread.append(threadEnd);

        // ------------------- Replace AbortIf, Return  -------------------
        final Register returnRegister = function.hasReturnValue() ?
                thread.newRegister("__retval", function.getFunctionType().getReturnType()) : null;
        for (Event e : thread.getEvents()) {
            if (e instanceof AbortIf abort) {
                final Event jumpToEnd = EventFactory.newJump(abort.getCondition(), threadEnd);
                jumpToEnd.addTags(abort.getTags());
                jumpToEnd.copyAllMetadataFrom(abort);
                abort.replaceBy(jumpToEnd);
            } else if (e instanceof Return ret) {
                final Expression retVal = ret.getValue().orElse(null);
                final List<Event> replacement = eventSequence(
                        returnRegister != null ? EventFactory.newLocal(returnRegister, retVal) : null,
                        EventFactory.newGoto(threadReturnLabel)
                );
                replacement.forEach(ev -> ev.copyAllMetadataFrom(e));
                e.replaceBy(replacement);
            }
        }
    }

    private void validateBeforeBuild() {
        if (threadGrid == null) {
            throw new ParsingException("Thread grid is not set");
        }
        if (!forwardFunctions.isEmpty()) {
            throw new ParsingException("Missing function definitions: %s",
                    String.join(",", forwardFunctions.keySet()));
        }
        if (currentFunction != null) {
            throw new ParsingException("Unclosed definition for function '%s'",
                    currentFunction.getName());
        }
        if (!blocks.isEmpty()) {
            throw new ParsingException("Unclosed blocks for labels %s",
                    String.join(",", blocks.stream().map(Label::getName).toList()));
        }
    }

    private Function getEntryPointFunction() {
        if (entryPointId == null) {
            throw new ParsingException("Cannot build the program, entryPointId is missing");
        }
        Expression expression = expressions.get(entryPointId);
        if (expression == null) {
            throw new ParsingException("Cannot build the program, missing function definition '%s'", entryPointId);
        }
        if (expression instanceof Function function) {
            return function;
        }
        throw new ParsingException("Entry point expression '%s' must be a function", entryPointId);
    }

    // TODO: Move to the corresponding visitors, tests, mocks etc ======================================================

    public FunctionType getCurrentFunctionType() {
        return getCurrentFunctionOrThrowError().getFunctionType();
    }

    public String getCurrentFunctionName() {
        return getCurrentFunctionOrThrowError().getName();
    }

    public Set<Function> getForwardFunctions() {
        return Set.copyOf(forwardFunctions.values());
    }

    public Map<Register, String> getPhiDefinitions(Label label) {
        return phiDefinitions.computeIfAbsent(label, k -> new HashMap<>());
    }

    public Map<String, Type> getTypes() {
        return Map.copyOf(types);
    }

    public Map<String, Expression> getExpressions() {
        return Map.copyOf(expressions);
    }

    public List<Label> getBlocks() {
        return blocks.stream().toList();
    }

    public MemoryObject getMemoryObject(String id) {
        return program.getMemory().getObjects().stream()
                .filter(o -> o.getCVar().equals(id))
                .findFirst()
                .orElseThrow(() -> new ParsingException("Undefined memory object '%s'", id));
    }

    public void setThreadGrid(List<Integer> threadGrid) {
        if (this.threadGrid != null) {
            throw new ParsingException("Thread grid is set multiple times");
        }
        if (threadGrid.size() != 3) {
            throw new ParsingException("Thread grid must have 3 dimensions");
        }
        if (threadGrid.stream().anyMatch(i -> i <= 0)) {
            throw new ParsingException("Thread grid dimensions must be positive");
        }
        if (threadGrid.stream().reduce(1, (a, b) -> a * b) > 128) {
            throw new ParsingException("Thread grid dimensions must be less than 128");
        }
        this.threadGrid = threadGrid;
    }
}
