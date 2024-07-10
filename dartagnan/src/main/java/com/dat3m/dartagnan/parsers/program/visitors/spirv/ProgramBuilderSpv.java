package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Decoration;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperDecorations;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags;
import com.dat3m.dartagnan.program.memory.ScopedPointer;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.transformers.MemoryTransformer;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.transformers.RegisterTransformer;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.functions.AbortIf;
import com.dat3m.dartagnan.program.event.functions.Return;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.program.Program.SpecificationType.FORALL;
import static com.dat3m.dartagnan.program.Program.SpecificationType.NOT_EXISTS;
import static com.dat3m.dartagnan.program.ScopeHierarchy.ScopeHierarchyForVulkan;
import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;

public class ProgramBuilderSpv {

    private static final Logger logger = LogManager.getLogger(ProgramBuilderSpv.class);

    protected final Map<String, Type> types = new HashMap<>();
    protected final Map<String, Expression> expressions = new HashMap<>();
    protected final Set<String> specConstants = new HashSet<>();
    protected final Map<String, Function> forwardFunctions = new HashMap<>();
    protected final Map<String, Label> labels = new HashMap<>();
    protected final Deque<Label> blocks = new ArrayDeque<>();
    protected final Map<Label, Event> blockEndEvents = new HashMap<>();
    protected final Map<Label, Map<Register, String>> phiDefinitions = new HashMap<>();
    protected final Map<Label, Label> cfDefinitions = new HashMap<>();
    protected final List<Integer> threadGrid;
    protected final Map<String, Expression> inputs;
    protected final Program program;

    protected Function currentFunction;
    protected String entryPointId;
    protected int nextFunctionId = 0;
    protected Set<String> nextOps;

    private final HelperTags helperTags = new HelperTags();
    private final HelperDecorations helperDecorations;

    public ProgramBuilderSpv(List<Integer> threadGrid, Map<String, Expression> inputs) {
        validateThreadGrid(threadGrid);
        this.threadGrid = threadGrid;
        this.inputs = inputs;
        this.program = new Program(new Memory(), Program.SourceLanguage.SPV);
        this.helperDecorations = new HelperDecorations(threadGrid);
    }

    private void validateThreadGrid(List<Integer> threadGrid) {
        if (threadGrid.size() != 4) {
            throw new ParsingException("Thread grid must have 4 dimensions");
        }
        if (threadGrid.stream().anyMatch(i -> i <= 0)) {
            throw new ParsingException("Thread grid dimensions must be positive");
        }
        if (threadGrid.stream().reduce(1, (a, b) -> a * b) > 128) {
            throw new ParsingException("Thread grid dimensions must be less than 128");
        }
    }

    public List<Integer> getThreadGrid() {
        return threadGrid;
    }

    public Set<String> getNextOps() {
        return nextOps;
    }

    public void setNextOps(Set<String> nextOps) {
        if (this.nextOps != null) {
            throw new ParsingException("Illegal attempt to override next ops");
        }
        this.nextOps = nextOps;
    }

    public void clearNextOps() {
        this.nextOps = null;
    }

    public Program build() {
        validateBeforeBuild();
        preprocessBlocks();
        Function entry = getEntryPointFunction();
        BuiltIn builtIn = (BuiltIn) getDecoration(DecorationType.BUILT_IN);
        Set<ScopedPointerVariable> variables = expressions.values().stream()
                .filter(ScopedPointerVariable.class::isInstance)
                .map(v -> (ScopedPointerVariable) v)
                .collect(Collectors.toSet());
        MemoryTransformer transformer = new MemoryTransformer(program, builtIn, variables);
        for (int z = 0; z < threadGrid.get(2); z++) {
            for (int y = 0; y < threadGrid.get(1); y++) {
                for (int x = 0; x < threadGrid.get(0); x++) {
                    program.addThread(createThreadFromFunction(entry, transformer, x, y, z));
                }
            }
        }
        // TODO: Cleanup local memory, old functions and undefined expressions from local memory

        checkSpecification();
        return program;
    }

    public void setEntryPointId(String id) {
        if (entryPointId != null) {
            throw new ParsingException("Multiple entry points are not supported");
        }
        entryPointId = id;
    }

    public void addAssertion(Program.SpecificationType type, Expression expression) {
        Expression specification = program.getSpecification();
        if (specification == null) {
            program.setSpecification(type, expression);
        } else if (type.equals(program.getSpecificationType())) {
            if (program.getSpecificationType().equals(FORALL)) {
                Expression result = ExpressionFactory.getInstance().makeAnd(specification, expression);
                program.setSpecification(type, result);
            } else if (program.getSpecificationType().equals(NOT_EXISTS)) {
                Expression result = ExpressionFactory.getInstance().makeOr(specification, expression);
                program.setSpecification(type, result);
            } else {
                throw new ParsingException("Multiline assertion is not supported for type " + type);
            }
        } else {
            throw new ParsingException("Mixed assertion type is not supported");
        }
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
        if (blockEndEvents.containsKey(label)) {
            throw new ParsingException("Attempt to redefine label '%s'", label.getName());
        }
        blocks.push(label);
    }

    public Event endBlock(Event event) {
        if (blocks.isEmpty()) {
            throw new ParsingException("Attempt to exit block while not in a block definition");
        }
        blockEndEvents.put(blocks.pop(), event);
        return event;
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

    public ScopedPointerVariable allocateMemoryVirtual(String id, String typeId, Type type, int bytes) {
        MemoryObject memoryObject = program.getMemory().allocateVirtual(bytes, true, null);
        memoryObject.setName(id);
        return new ScopedPointerVariable(id, ((ScopedPointerType) getType(typeId)).getScopeId(), type, memoryObject);
    }

    public Expression newUndefinedValue(Type type) {
        return program.newConstant(type);
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

    public List<ScopedPointerVariable> getVariablesWithStorageClass(String storageClass) {
        return expressions.values().stream()
                .filter(ScopedPointerVariable.class::isInstance)
                .map(e -> (ScopedPointerVariable)e)
                .filter(e -> e.getScopeId().equals(storageClass))
                .toList();
    }

    public String getExpressionStorageClass(String name) {
        Expression expression = getExpression(name);
        if (expression instanceof ScopedPointer pExpr) {
            return pExpr.getScopeId();
        }
        if (expression instanceof Register) {
            // TODO: Hacky, ideally new pointer type for registers
            return Tag.Spirv.SC_FUNCTION;
        }
        throw new ParsingException("Reference to undefined pointer '%s'", name);
    }

    public Label makeBranchBackJumpLabel(Label label) {
        String id = label.getName() + "_back";
        if (labels.containsKey(id)) {
            throw new ParsingException("Overlapping blocks with back jump in label '%s'", label.getName());
        }
        return getOrCreateLabel(id);
    }

    public int getExpressionAsConstInteger(String id) {
        Expression expression = getExpression(id);
        if (expression instanceof IntLiteral iExpr) {
            return iExpr.getValueAsInt();
        }
        throw new ParsingException("Expression '%s' is not an integer constant", id);
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

    public boolean hasInput(String id) {
        return inputs.containsKey(id);
    }

    public Expression getInput(String id) {
        if (inputs.containsKey(id)) {
            return inputs.get(id);
        }
        throw new ParsingException("Reference to undefined input variable '%s'", id);
    }

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
        if (getType(typeId) instanceof ScopedPointerType) {
            throw new ParsingException("Register cannot be a pointer");
        }
        return getCurrentFunctionOrThrowError().newRegister(id, getType(typeId));
    }

    public boolean hasBlock(String id) {
        if (!labels.containsKey(id)) {
            return false;
        }
        Label label = labels.get(id);
        return blockEndEvents.containsKey(label) || blocks.contains(label);
    }

    public Label getOrCreateLabel(String id) {
        Label label = labels.computeIfAbsent(id, EventFactory::newLabel);
        if (label.getFunction() == null) {
            label.setFunction(getCurrentFunctionOrThrowError());
        }
        return label;
    }

    public String getScope(String id) {
        return helperTags.visitScope(id, getExpression(id));
    }

    public boolean isSemanticsNone(String id) {
        return helperTags.isMemorySemanticsNone(id, getExpression(id));
    }

    public Set<String> getSemantics(String id) {
        return helperTags.visitIdMemorySemantics(id, getExpression(id));
    }

    public String getStorageClass(String raw) {
        return helperTags.visitStorageClass(raw);
    }

    public Decoration getDecoration(DecorationType type) {
        return helperDecorations.getDecoration(type);
    }

    private Function getCurrentFunctionOrThrowError() {
        if (currentFunction != null) {
            return currentFunction;
        }
        throw new ParsingException("Attempt to reference current function " +
                "outside of a function definition");
    }

    private Thread createThreadFromFunction(Function function, MemoryTransformer transformer, int x, int y, int z) {
        int tid = x + y * threadGrid.get(0) + z * threadGrid.get(0) * threadGrid.get(1);
        ScopeHierarchy scope = ScopeHierarchyForVulkan(0, z, y);
        Thread thread = createThread(tid, scope, function);
        copyEvents(tid, thread, function);

        // Create thread-local variables
        transformer.setHierarchy(List.of(x, y, z, 0));
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
        if (nextOps != null) {
            throw new ParsingException("Missing expected op: %s",
                    String.join(",", nextOps));
        }
        // TODO: Validate no event refers to an undefined label
    }

    private void preprocessBlocks() {
        Map<Event, Label> blockEndToLabelMap = new HashMap<>();
        for (Map.Entry<Label, Event> entry : blockEndEvents.entrySet()) {
            if (blockEndToLabelMap.containsKey(entry.getValue())) {
                throw new ParsingException("Malformed control flow, " +
                        "multiple block refer to the same end event " + entry.getValue());
            }
            blockEndToLabelMap.put(entry.getValue(), entry.getKey());
        }
        insertPhiDefinitions(blockEndToLabelMap);
        insertBlockEndLabels(blockEndToLabelMap);
    }

    private void checkSpecification() {
        if (program.getSpecification() == null) {
            logger.warn("The program has no explicitly defined specification, " +
                    "setting a trivial assertion");
            program.setSpecification(FORALL, ExpressionFactory.getInstance().makeTrue());
        }
    }

    public void addPhiDefinition(Label label, Register register, String id) {
        phiDefinitions.computeIfAbsent(label, k -> new HashMap<>()).put(register, id);
    }

    private void insertPhiDefinitions(Map<Event, Label> blockEndToLabelMap) {
        for (Function function : program.getFunctions()) {
            for (Event event : function.getEvents()) {
                Label label = blockEndToLabelMap.get(event.getSuccessor());
                if (label != null) {
                    Map<Register, String> phi = phiDefinitions.get(label);
                    if (phi != null) {
                        for (Map.Entry<Register, String> entry : phi.entrySet()) {
                            event.insertAfter(new Local(entry.getKey(), getExpression(entry.getValue())));
                        }
                    }
                }
            }
        }
    }

    private void insertBlockEndLabels(Map<Event, Label> blockEndToLabelMap) {
        for (Function function : program.getFunctions()) {
            for (Event event : function.getEvents()) {
                Label label = blockEndToLabelMap.get(event.getSuccessor());
                if (label != null) {
                    Label endLabel = cfDefinitions.get(label);
                    if (endLabel != null) {
                        event.insertAfter(endLabel);
                    }
                }
            }
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

    public Label makeBranchEndLabel(Label label) {
        String id = label.getName() + "_end";
        if (labels.containsKey(id)) {
            throw new ParsingException("Overlapping blocks with endpoint in label '%s'", label.getName());
        }
        Label endLabel = getOrCreateLabel(id);
        cfDefinitions.put(label, endLabel);
        return endLabel;
    }
}
