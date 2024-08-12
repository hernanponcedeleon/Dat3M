package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.type.VoidType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.memory.ScopedPointer;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;

import java.util.*;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.program.event.EventFactory.newValueFunctionCall;
import static com.dat3m.dartagnan.program.event.EventFactory.newVoidFunctionCall;

public class VisitorOpsFunction extends SpirvBaseVisitor<Void> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private final ProgramBuilder builder;
    private String currentId;
    private FunctionType currentType;
    private List<String> currentArgs;
    private int nextFunctionId = 0;

    final Map<String, Function> forwardFunctions = new HashMap<>();
    final Map<String, Set<FunctionCall>> forwardCalls = new HashMap<>();

    public VisitorOpsFunction(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Void visitOpFunction(SpirvParser.OpFunctionContext ctx) {
        String id = ctx.idResult().getText();
        String typeName = ctx.functionType().getText();
        Type type = builder.getType(typeName);
        if (type instanceof FunctionType fType) {
            String returnTypeName = ctx.idResultType().getText();
            Type returnType = builder.getType(returnTypeName);
            if (!returnType.equals(fType.getReturnType())) {
                throw new ParsingException("Failed to create function '%s'. " +
                        "Illegal return type: expected %s but received %s",
                        id, fType.getReturnType().getClass().getSimpleName(),
                        returnType.getClass().getSimpleName());
            }
            currentId = id;
            currentType = fType;
            currentArgs = new ArrayList<>();
            if (currentType.getParameterTypes().isEmpty()) {
                createFunction();
            }
            return null;
        }
        throw new ParsingException("Failed to create function '%s'. " +
                "Illegal variable type '%s': expected %s but received %s",
                id, typeName, FunctionType.class.getSimpleName(),
                type.getClass().getSimpleName());
    }

    @Override
    public Void visitOpFunctionParameter(SpirvParser.OpFunctionParameterContext ctx) {
        String id = ctx.idResult().getText();
        if (currentId == null || currentType == null || currentArgs == null) {
            throw new ParsingException("Attempt to declare function parameter '%s' " +
                    "outside of a function definition", id);
        }
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof ScopedPointerType)) {
            throw new ParsingException("Attempt to use a non-pointer type for parameter '%s " +
                    "in function '%s'", id, currentId);
        }
        List<Type> argTypes = currentType.getParameterTypes();
        int idx = currentArgs.size();
        if (idx >= argTypes.size() || !type.equals(argTypes.get(idx))) {
            throw new ParsingException("Mismatching argument type in function '%s' " +
                    "for argument '%s'", currentId, id);
        }
        if (currentArgs.contains(id)) {
            throw new ParsingException("Duplicated parameter id '%s' in function '%s'", id, currentId);
        }
        currentArgs.add(id);
        if (currentArgs.size() == currentType.getParameterTypes().size()) {
            createFunction();
        }
        return null;
    }

    @Override
    public Void visitOpFunctionEnd(SpirvParser.OpFunctionEndContext ctx) {
        builder.endCurrentFunction();
        return null;
    }

    @Override
    public Void visitOpFunctionCall(SpirvParser.OpFunctionCallContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        String functionId = ctx.function().getText();
        Type returnType = builder.getType(typeId);
        List<Expression> args = ctx.argument().stream()
                .map(a -> builder.getExpression(a.getText())).toList();
        List<Type> argTypes = args.stream()
                .map(e -> e instanceof ScopedPointer pBase
                        ? types.getScopedPointerType(pBase.getScopeId(), pBase.getInnerType())
                        : e.getType()).toList();
        FunctionType functionType = types.getFunctionType(builder.getType(typeId), argTypes);
        Function function = getCalledFunction(functionId, functionType);
        FunctionCall event;
        if (returnType instanceof VoidType) {
            event = newVoidFunctionCall(function, args);
        } else {
            Register register = builder.addRegister(id, typeId);
            event = newValueFunctionCall(register, function, args);
        }
        if (!builder.hasDefinition(functionId)) {
            forwardCalls.computeIfAbsent(functionId, x -> new HashSet<>()).add(event);
        }
        builder.addEvent(event);
        return null;
    }

    private void createFunction() {
        Function function = new Function(currentId, currentType, currentArgs, nextFunctionId++, null);
        builder.startCurrentFunction(function);
        if (forwardFunctions.containsKey(currentId)) {
            Function forwardFunction = forwardFunctions.remove(currentId);
            checkFunctionType(currentId, forwardFunction, currentType);
            forwardCalls.remove(currentId).forEach(e -> e.setCallTarget(function));
        }
        currentId = null;
        currentType = null;
        currentArgs = null;
    }

    private Function getCalledFunction(String id, FunctionType type) {
        if (builder.hasDefinition(id)) {
            Expression expression = builder.getExpression(id);
            if (expression instanceof Function function) {
                checkFunctionType(id, function, type);
                return function;
            }
            throw new ParsingException("Unexpected type of expression '%s', " +
                    "expected a function but received '%s'", id, expression.getType());
        }
        if (forwardFunctions.containsKey(id)) {
            Function function = forwardFunctions.get(id);
            checkFunctionType(id, function, type);
            return function;
        }
        List<String> args = IntStream.range(0, type.getParameterTypes().size())
                .boxed().map(i -> "param_" + i)
                .toList();
        Function function = new Function(id, type, args, nextFunctionId++, null);
        forwardFunctions.put(id, function);
        return function;
    }

    private void checkFunctionType(String id, Function function, Type type) {
        if (!function.getFunctionType().equals(type)) {
            throw new ParsingException("Illegal call of function '%s', " +
                    "function type doesn't match the function definition", id);
        }
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpFunction",
                "OpFunctionParameter",
                "OpFunctionEnd",
                "OpFunctionCall"
        );
    }
}
