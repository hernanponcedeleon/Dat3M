package com.dat3m.dartagnan.parsers.program.visitors.spirv.utils;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.Decoration;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperDecorations;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags;
import com.dat3m.dartagnan.program.memory.ScopedPointer;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.program.*;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class ProgramBuilder {

    protected final Map<String, Type> types = new HashMap<>();
    protected final Map<String, Expression> expressions = new HashMap<>();
    protected final Map<String, Expression> inputs = new HashMap<>();
    protected final Map<String, Function> forwardFunctions = new HashMap<>();
    protected final ThreadGrid grid;
    protected final Program program;
    protected Function currentFunction;
    protected String entryPointId;
    protected int nextFunctionId = 0;
    protected Set<String> nextOps;
    protected ControlFlowBuilder cfBuilder = new ControlFlowBuilder(expressions);
    private final HelperTags helperTags = new HelperTags();
    private final HelperDecorations helperDecorations;

    public ProgramBuilder(ThreadGrid grid) {
        this.grid = grid;
        this.program = new Program(new Memory(), Program.SourceLanguage.SPV);
        this.helperDecorations = new HelperDecorations(grid);
    }

    public Program build() {
        validateBeforeBuild();
        cfBuilder.build();
        BuiltIn builtIn = (BuiltIn) getDecoration(DecorationType.BUILT_IN);
        Set<ScopedPointerVariable> variables = expressions.values().stream()
                .filter(ScopedPointerVariable.class::isInstance)
                .map(v -> (ScopedPointerVariable) v)
                .collect(Collectors.toSet());
        new ThreadCreator(grid, getEntryPointFunction(), variables, builtIn).create();
        return program;
    }

    public ThreadGrid getThreadGrid() {
        return grid;
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

    public void setEntryPointId(String id) {
        if (entryPointId != null) {
            throw new ParsingException("Multiple entry points are not supported");
        }
        entryPointId = id;
    }

    public void setSpecification(Program.SpecificationType type, Expression assertion) {
        if (program.getSpecification() != null) {
            throw new ParsingException("Attempt to override program specification");
        }
        program.setSpecification(type, assertion);
    }

    public Expression getInput(String id) {
        if (inputs.containsKey(id)) {
            return inputs.get(id);
        }
        throw new ParsingException("Reference to undefined input variable '%s'", id);
    }

    public void addInput(String id, Expression value) {
        if (inputs.containsKey(id)) {
            throw new ParsingException("Duplicated definition '%s'", id);
        }
        inputs.put(id, value);
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

    public Event addEvent(Event event) {
        if (currentFunction == null) {
            throw new ParsingException("Attempt to add an event outside a function definition");
        }
        if (!cfBuilder.isInsideBlock()) {
            throw new ParsingException("Attempt to add an event outside a control flow block");
        }
        if (event instanceof RegWriter regWriter) {
            Register register = regWriter.getResultRegister();
            addExpression(register.getName(), register);
        }
        currentFunction.append(event);
        return event;
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

    public ScopedPointerVariable allocateMemoryVirtual(String id, String typeId, Type type, int bytes) {
        MemoryObject memoryObject = program.getMemory().allocateVirtual(bytes, true, null);
        memoryObject.setName(id);
        return new ScopedPointerVariable(id, ((ScopedPointerType) getType(typeId)).getScopeId(), type, memoryObject);
    }

    public Expression newUndefinedValue(Type type) {
        return program.newConstant(type);
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

    public boolean hasInput(String id) {
        return inputs.containsKey(id);
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

    public ControlFlowBuilder getHelperControlFlow() {
        return cfBuilder;
    }

    public Function getCurrentFunctionOrThrowError() {
        if (currentFunction != null) {
            return currentFunction;
        }
        throw new ParsingException("Attempt to reference current function " +
                "outside of a function definition");
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
        if (nextOps != null) {
            throw new ParsingException("Missing expected op: %s",
                    String.join(",", nextOps));

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
            if (function.hasReturnValue()) {
                throw new ParsingException("Entry point function %s is not a void function", entryPointId);
            }
            return function;
        }
        throw new ParsingException("Entry point expression '%s' must be a function", entryPointId);
    }

    public FunctionType getCurrentFunctionType() {
        return getCurrentFunctionOrThrowError().getFunctionType();
    }

    public String getCurrentFunctionName() {
        return getCurrentFunctionOrThrowError().getName();
    }
}
