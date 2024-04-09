package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Decoration;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperDecorations;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.transformers.MemoryTransformer;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.transformers.RegisterTransformer;
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
import com.dat3m.dartagnan.program.specification.*;
import com.google.common.collect.Lists;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.program.ScopeHierarchy.ScopeHierarchyForVulkan;
import static com.dat3m.dartagnan.program.event.EventFactory.eventSequence;
import static com.dat3m.dartagnan.program.specification.AbstractAssert.ASSERT_TYPE_FORALL;

public class ProgramBuilderSpv {

    private static final Logger logger = LogManager.getLogger(ProgramBuilderSpv.class);

    private final HelperTags helperTags = new HelperTags();
    private final HelperDecorations helperDecorations = new HelperDecorations();
    private final Map<String, Type> types = new HashMap<>();
    private final Map<String, String> pointedTypes = new HashMap<>();
    private final Map<String, Type> variableTypes = new HashMap<>();
    private final Map<String, String> pointerClasses = new HashMap<>();
    private final Map<String, String> registerClasses = new HashMap<>();
    private final Map<String, Expression> expressions = new HashMap<>();
    private final Map<String, Function> forwardFunctions = new HashMap<>();
    private final Map<String, Label> labels = new HashMap<>();
    private final Deque<Label> blocks = new ArrayDeque<>();
    private final Map<Label, Event> blockEndEvents = new HashMap<>();
    private final Map<Label, Map<Register, String>> phiDefinitions = new HashMap<>();
    private final Map<Label, Label> cfDefinitions = new HashMap<>();
    private final Set<String> specConstants = new HashSet<>();
    private final Map<String, Expression> inputs = new HashMap<>();
    private final Program program;
    protected Function currentFunction;
    private List<Integer> threadGrid = List.of(1, 1, 1);
    private String entryPointId;
    private int nextFunctionId = 0;
    private Set<String> nextOps;

    public ProgramBuilderSpv() {
        this.program = new Program(new Memory(), Program.SourceLanguage.SPV);
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
        MemoryTransformer transformer = new MemoryTransformer(program, builtIn, variableTypes, registerClasses);
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

    public void addAssertion(AbstractAssert ast) {
        AbstractAssert spec = program.getSpecification();
        if (spec == null) {
            program.setSpecification(ast);
        } else if (spec.isSafetySpec() && ast.isSafetySpec()) {
            AbstractAssert result = new AssertCompositeAnd(getAssertForAll(spec), getAssertForAll(ast));
            result.setType(ASSERT_TYPE_FORALL);
            program.setSpecification(result);
        } else {
            throw new ParsingException("Existential assertions can not be used in conjunction with other assertions");
        }
    }

    private AbstractAssert getAssertForAll(AbstractAssert assertion) {
        return assertion.getType().equals(ASSERT_TYPE_FORALL) ? assertion : getComplement(assertion);
    }

    private AbstractAssert getComplement(AbstractAssert assertion) {
        if (assertion instanceof AssertCompositeAnd andAssertion) {
            return new AssertCompositeOr(getComplement(andAssertion.getLeft()),
                    getComplement(andAssertion.getRight()));
        } else if (assertion instanceof AssertCompositeOr orAssertion) {
            return new AssertCompositeAnd(getComplement(orAssertion.getLeft()),
                    getComplement(orAssertion.getRight()));
        }
        return new AssertNot(assertion);
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

    public MemoryObject allocateMemory(int bytes) {
        return program.getMemory().allocate(bytes);
    }

    public MemoryObject allocateMemoryVirtual(int bytes) {
        return program.getMemory().allocateVirtual(bytes, true, null);
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
        if (TypeFactory.getInstance().isPointerType(type)) {
            throw new ParsingException("Unexpected pointer type '%s'", name);
        }
        types.put(name, type);
        return type;
    }

    public Type addPointerType(String name, String innerTypeId, String cls) {
        if (types.containsKey(name) || expressions.containsKey(name)) {
            throw new ParsingException("Duplicated definition '%s'", name);
        }
        if (pointedTypes.containsKey(name)) {
            throw new ParsingException("Duplicated pointer type definition '%s'", name);
        }
        getType(innerTypeId);
        pointedTypes.put(name, innerTypeId);
        if (pointerClasses.containsKey(name)) {
            throw new ParsingException("Duplicated variable storage class definition '%s'", name);
        }
        pointerClasses.put(name, getStorageClass(cls));
        Type type = TypeFactory.getInstance().getPointerType();
        types.put(name, type);
        return type;
    }

    public Type getPointedType(String name) {
        String typeId = pointedTypes.get(name);
        if (typeId == null) {
            if (!types.containsKey(name)) {
                throw new ParsingException("Reference to undefined pointer type '%s'", name);
            }
            throw new ParsingException("Type '%s' is not a pointer type", name);
        }
        return getType(typeId);
    }

    public Type getVariableType(String name) {
        Type type = variableTypes.get(name);
        if (type == null) {
            throw new ParsingException("Reference to undefined variable '%s'", name);
        }
        return type;
    }

    public Type addVariableType(String name, Type type) {
        if (variableTypes.containsKey(name)) {
            throw new ParsingException("Duplicated variable type definition '%s'", name);
        }
        variableTypes.put(name, type);
        return type;
    }

    public String getExpressionStorageClass(String name) {
        String storageClass = registerClasses.get(name);
        if (storageClass == null) {
            throw new ParsingException("Reference to undefined pointer '%s'", name);
        }
        return storageClass;
    }

    public Label makeBranchBackJumpLabel(Label label) {
        String id = label.getName() + "_back";
        if (labels.containsKey(id)) {
            throw new ParsingException("Overlapping blocks with back jump in label '%s'", label.getName());
        }
        return getOrCreateLabel(id);
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

    public void addInput(String name, Expression value) {
        if (inputs.containsKey(name)) {
            throw new ParsingException("Duplicated definition '%s'", name);
        }
        inputs.put(name, value);
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
        addStorageClassForExpr(id, typeId);
        return getCurrentFunctionOrThrowError().newRegister(id, getType(typeId));
    }

    public String addStorageClassForExpr(String id, String typeId) {
        if (pointedTypes.containsKey(typeId)) {
            String storageClass = pointerClasses.get(typeId);
            if (storageClass == null) {
                throw new ParsingException("Missing storage class for pointer '%s'", typeId);
            }
            if (registerClasses.containsKey(id)) {
                throw new ParsingException("Duplicated storage class definition  for expression'%s'", id);
            }
            registerClasses.put(id, storageClass);
            return storageClass;
        }
        // TODO:
        return null;
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
            AssertTrue ast = new AssertTrue();
            ast.setType(ASSERT_TYPE_FORALL);
            program.setSpecification(ast);
        }
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

    public Set<Function> getForwardFunctions() {
        return Set.copyOf(forwardFunctions.values());
    }

    public Map<Label, Event> getBlockEndEvents() {
        return Map.copyOf(blockEndEvents);
    }

    public Map<Label, Label> getCfDefinition() {
        return Map.copyOf(cfDefinitions);
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
                .filter(o -> o.getName().equals(id))
                .findFirst()
                .orElseThrow(() -> new ParsingException("Undefined memory object '%s'", id));
    }

    public void setThreadGrid(List<Integer> threadGrid) {
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
        BuiltIn builtIn = new BuiltIn(threadGrid.get(0), threadGrid.get(1), threadGrid.get(2), 1);
        helperDecorations.addDecorationIfAbsent(DecorationType.BUILT_IN, builtIn);
    }

    public void addBuiltInDecorationIfAbsent() {
        BuiltIn builtIn = new BuiltIn(this.threadGrid.get(0), this.threadGrid.get(1), this.threadGrid.get(2), 1);
        helperDecorations.addDecorationIfAbsent(DecorationType.BUILT_IN, builtIn);
    }
}
