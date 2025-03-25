package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperInputs;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTypes;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.functions.FunctionCall;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.memory.ScopedPointer;

import java.util.*;
import java.util.stream.IntStream;

import static com.dat3m.dartagnan.program.event.EventFactory.newValueFunctionCall;
import static com.dat3m.dartagnan.program.event.EventFactory.newVoidFunctionCall;

public class VisitorOpsFunction extends SpirvBaseVisitor<Void> {

    private static final int DEFAULT_INPUT_SIZE = 10;
    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final Map<String, Function> forwardFunctions = new HashMap<>();
    private final Map<String, Set<FunctionCall>> forwardCalls = new HashMap<>();
    private final Map<String, Expression> parameters = new HashMap<>();
    private final ProgramBuilder builder;
    private String currentId;
    private FunctionType currentType;
    private List<String> currentArgs;
    private int nextFunctionId = 0;

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
        if (currentId.equals(builder.getEntryPointId())) {
            Expression result = createEntryPointParameter(id, type);
            parameters.put(id, result);
            //System.out.println(id + " " + result);
        }
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
        function.getParameterRegisters().forEach(r -> builder.addExpression(r.getName(), r));
        if (currentId.equals(builder.getEntryPointId())) {
            function.getParameterRegisters().forEach(r -> {
                Local local = EventFactory.newLocal(r, parameters.get(r.getName()));
                local.addTags(Tag.NOOPT);
                function.append(local);
            });
        }
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

    private Expression createEntryPointParameter(String id, Type type) {
        Expression value = createEntryPointParameterValue(id, type);
        //System.out.println("value=" + value);
        if (type instanceof ScopedPointerType pType) {
            String ptrId = HelperInputs.castPointerId(id);
            pType = types.getScopedPointerType(pType.getScopeId(), value.getType());
            MemoryObject memObj = builder.allocateMemory(ptrId, pType.getScopeId(), value);
            ScopedPointer pointer = expressions.makeScopedPointer(ptrId, pType, memObj);
            builder.addExpression(ptrId, pointer);
            //System.out.println(ptrId + " " + pointer + " " + pointer.getAddress().getClass().getSimpleName() + " " + pointer.getInnerType());
            value = pointer.getAddress();
        }
        return value;
    }

    /*
    private int getFirstElementDepth(String id, Type type) {
        if (type instanceof ArrayType || type instanceof AggregateType) {
            Type elementType = HelperTypes.getMemberType(id, type, List.of(0));
            return 1 + getFirstElementDepth(id, elementType);
        }
        return 0;
    }

    private void createParameterVariable(String id, Type type) {
        if (type instanceof ScopedPointerType pType) {
            Expression externalValue = createExternalVariable(id, pType);
            ScopedPointer aggregatePointer = builder.allocateScopedPointerVariable(
                    HelperInputs.castPointerId(id), externalValue, pType.getScopeId(), externalValue.getType());
            Expression zero = ExpressionFactory.getInstance().makeZero(TypeFactory.getInstance().getArchType());
            int depth = getFirstElementDepth(id, pType.getPointedType());
            List<Expression> indexes = Collections.nCopies(depth, zero);
            Expression ptr = HelperTypes.getMemberAddress(id, aggregatePointer.getAddress(), externalValue.getType(), indexes);
            builder.addExpression(HelperInputs.castPointerId(id), aggregatePointer);
            addParameterVariable(id, ptr);
        } else {
            if (builder.hasInput(id)) {
                Expression input = builder.getInput(id);
                Expression ptr = HelperInputs.castInput(id, type, input);
                addParameterVariable(id, ptr);
            }
        }
    }*/

    private Expression createEntryPointParameterValue(String id, Type type) {
        if (builder.hasInput(id)) {
            Expression input = builder.getInput(id);
            //if (type instanceof ScopedPointerType pType) {
                //System.out.println("pointer type: " + pType.getPointedType());
                //type = HelperInputs.castInputType(id, pType, input.getType());
                //type = pType.getPointedType();
            //}
            //System.out.println("type: " + type);
            //System.out.println("input before: " + input);
            Expression result = HelperInputs.castInput(id, type, input);
            //System.out.println("input after: " + result);
            return result;
        }
        if (type instanceof ScopedPointerType pType) {
            type = types.getArrayType(pType.getPointedType(), DEFAULT_INPUT_SIZE);
        }
        return builder.makeUndefinedValue(type);
    }

    Map<String, Set<FunctionCall>> getForwardCalls() {
        return Collections.unmodifiableMap(forwardCalls);
    }

    Map<String, Function> getForwardFunctions() {
        return Collections.unmodifiableMap(forwardFunctions);
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
