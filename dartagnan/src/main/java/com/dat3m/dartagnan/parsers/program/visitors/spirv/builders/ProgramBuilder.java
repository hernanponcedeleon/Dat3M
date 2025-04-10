package com.dat3m.dartagnan.parsers.program.visitors.spirv.builders;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ThreadGrid;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.program.processing.transformers.MemoryTransformer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.BUILT_IN;

public class ProgramBuilder {

    protected final Map<String, Type> types = new HashMap<>();
    protected final Map<String, Expression> expressions = new HashMap<>();
    protected final Map<String, Expression> inputs = new HashMap<>();
    protected final Map<String, String> debugInfos = new HashMap<>();
    protected final List<Integer> scopeSizes;
    protected ThreadGrid grid;
    protected Program program;
    protected ControlFlowBuilder controlFlowBuilder;
    protected DecorationsBuilder decorationsBuilder;
    protected Function currentFunction;
    protected String entryPointId;
    protected Arch arch;
    protected Set<String> nextOps;

    public ProgramBuilder(List<Integer> scopeSizes) {
        this.scopeSizes = scopeSizes;
        this.program = new Program(new Memory(), Program.SourceLanguage.SPV);
        this.controlFlowBuilder = new ControlFlowBuilder(expressions);
        this.decorationsBuilder = new DecorationsBuilder();
    }

    public Program build() {
        validateBeforeBuild();
        controlFlowBuilder.build();
        BuiltIn builtIn = (BuiltIn) decorationsBuilder.getDecoration(BUILT_IN);
        MemoryTransformer transformer = new MemoryTransformer(grid, getEntryPointFunction(), builtIn, getVariables());
        program.addTransformer(transformer);
        return program;
    }

    public ThreadGrid getThreadGrid() {
        return grid;
    }

    public ControlFlowBuilder getControlFlowBuilder() {
        return controlFlowBuilder;
    }

    public DecorationsBuilder getDecorationsBuilder() {
        return decorationsBuilder;
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

    public String getEntryPointId() {
        return entryPointId;
    }

    public void setEntryPointId(String id) {
        if (entryPointId != null) {
            throw new ParsingException("Multiple entry points are not supported");
        }
        entryPointId = id;
        program.setEntryPoint(id);
    }

    public void setArch(Arch arch) {
        if (this.arch != null) {
            throw new ParsingException("Illegal attempt to override memory model");
        }
        this.arch = arch;
        if (arch.equals(Arch.VULKAN)) {
            grid = ThreadGrid.ThreadGridForVulkan(scopeSizes);
        } else if (arch.equals(Arch.OPENCL)) {
            grid = ThreadGrid.ThreadGridForOpenCL(scopeSizes);
        } else {
            throw new ParsingException("Unsupported architecture: " + arch);
        }
        program.setArch(arch);
        program.setGrid(grid);
        decorationsBuilder.setThreadGrid(grid);
    }

    public void setSpecification(Program.SpecificationType type, Expression condition) {
        if (program.getSpecification() != null) {
            throw new ParsingException("Attempt to override program specification");
        }
        program.setSpecification(type, condition);
    }

    public void setFilterSpecification(Expression condition) {
        if (program.getFilterSpecification() != null) {
            throw new ParsingException("Attempt to override program filter specification");
        }
        program.setFilterSpecification(condition);
    }

    public boolean hasInput(String id) {
        return inputs.containsKey(id);
    }

    public boolean hasDefinition(String id) {
        return types.containsKey(id) || expressions.containsKey(id);
    }

    public Expression getInput(String id) {
        if (inputs.containsKey(id)) {
            return inputs.get(id);
        }
        throw new ParsingException("Reference to undefined input variable '%s'", id);
    }

    public void addInput(String id, Expression value) {
        if (inputs.containsKey(id)) {
            throw new ParsingException("Duplicated input definition '%s'", id);
        }
        inputs.put(id, value);
    }

    public Type getType(String id) {
        Type type = types.get(id);
        if (type == null) {
            throw new ParsingException("Reference to undefined type '%s'", id);
        }
        return type;
    }

    public Type addType(String id, Type type) {
        if (types.containsKey(id) || expressions.containsKey(id)) {
            throw new ParsingException("Duplicated definition '%s'", id);
        }
        types.put(id, type);
        return type;
    }

    public Expression getExpression(String id) {
        Expression expression = expressions.get(id);
        if (expression == null) {
            throw new ParsingException("Reference to undefined expression '%s'", id);
        }
        return expression;
    }

    public Expression addExpression(String id, Expression value) {
        if (types.containsKey(id) || expressions.containsKey(id)) {
            throw new ParsingException("Duplicated definition '%s'", id);
        }
        expressions.put(id, value);
        return value;
    }

    public Set<ScopedPointerVariable> getVariables() {
        return expressions.values().stream()
                .filter(ScopedPointerVariable.class::isInstance)
                .map(v -> (ScopedPointerVariable) v)
                .collect(Collectors.toSet());
    }

    public MemoryObject allocateVariable(String id, int bytes) {
        MemoryObject memObj = program.getMemory().allocateVirtual(bytes, true, null);
        memObj.setName(id);
        return memObj;
    }

    public ScopedPointerVariable allocateScopedPointerVariable(String id, Expression initValue, String storageClass, Type pointedType) {
        MemoryObject memObj = allocateVariable(id, TypeFactory.getInstance().getMemorySizeInBytes(pointedType));
        memObj.setIsThreadLocal(false);
        memObj.setInitialValue(0, initValue);
        if (arch == Arch.OPENCL) {
            String openCLSpace = Tag.Spirv.toOpenCLTag(Tag.Spirv.getStorageClassTag(Set.of(storageClass)));
            memObj.addFeatureTag(openCLSpace);
        }
        return ExpressionFactory.getInstance().makeScopedPointerVariable(
                id, storageClass, pointedType, memObj);
    }

    public String getPointerStorageClass(String id) {
        Expression expression = getExpression(id);
        if (expression.getType() instanceof ScopedPointerType pointerType) {
            return pointerType.getScopeId();
        }
        throw new ParsingException("Reference to undefined pointer '%s'", id);
    }

    // TODO: Remove after updating OpLoad to use vector registers
    public Register addRegister(String id, Type type) {
        return getCurrentFunctionOrThrowError().newRegister(id, type);
    }

    public Register addRegister(String id, String typeId) {
        return getCurrentFunctionOrThrowError().newRegister(id, getType(typeId));
    }

    public Expression makeUndefinedValue(Type type) {
        return program.newConstant(type);
    }

    public Event addEvent(Event event) {
        if (currentFunction == null) {
            throw new ParsingException("Attempt to add an event outside a function definition");
        }
        if (!controlFlowBuilder.isInsideBlock()) {
            throw new ParsingException("Attempt to add an event outside a control flow block");
        }
        if (controlFlowBuilder.hasCurrentLocation()) {
            event.setMetadata(controlFlowBuilder.getCurrentLocation());
        }
        if (event instanceof RegWriter regWriter) {
            Register register = regWriter.getResultRegister();
            addExpression(register.getName(), register);
        }
        currentFunction.append(event);
        return event;
    }

    public FunctionType getCurrentFunctionType() {
        return getCurrentFunctionOrThrowError().getFunctionType();
    }

    public String getCurrentFunctionName() {
        return getCurrentFunctionOrThrowError().getName();
    }

    public void startCurrentFunction(Function function) {
        if (currentFunction != null) {
            throw new ParsingException("Attempt to define function '%s' " +
                    "inside a definition of another function '%s'",
                    function.getName(), currentFunction.getName());
        }
        addExpression(function.getName(), function);
        program.addFunction(function);
        currentFunction = function;
    }

    public void endCurrentFunction() {
        if (currentFunction == null) {
            throw new ParsingException("Illegal attempt to exit a function definition");
        }
        currentFunction = null;
    }

    public void addDebugInfo(String id, String info) {
        if (debugInfos.containsKey(id)) {
            throw new ParsingException("Attempt to add debug information with duplicate id");
        }
        debugInfos.put(id, info);
    }

    public String getDebugInfo(String id) {
        if (!debugInfos.containsKey(id)) {
            throw new ParsingException("No debug information with id '%s'", id);
        }
        return debugInfos.get(id);
    }

    private void validateBeforeBuild() {
        if (nextOps != null) {
            throw new ParsingException("Missing expected op: %s",
                    String.join(",", nextOps));

        }
        if (currentFunction != null) {
            throw new ParsingException("Unclosed definition for function '%s'",
                    currentFunction.getName());
        }
        expressions.values().forEach(expression -> {
            if (expression instanceof Function function) {
                function.getEvents().forEach(event -> {
                    if (event instanceof FunctionCall call) {
                        String calledId = call.getCalledFunction().getName();
                        if (!expressions.containsKey(calledId)
                                || !(expressions.get(calledId) instanceof Function)) {
                            throw new ParsingException("Call to undefined function '%s'", calledId);
                        }
                    }
                });
            }
        });
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
            if (function.hasReturnValue()) {
                throw new ParsingException("Entry point function %s is not a void function", entryPointId);
            }
            return function;
        }
        throw new ParsingException("Entry point expression '%s' must be a function", entryPointId);
    }

    private Function getCurrentFunctionOrThrowError() {
        if (currentFunction != null) {
            return currentFunction;
        }
        throw new ParsingException("Attempt to reference current function " +
                "outside of a function definition");
    }
}
