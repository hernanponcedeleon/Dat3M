package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.type.VoidType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.newValueFunctionCall;
import static com.dat3m.dartagnan.program.event.EventFactory.newVoidFunctionCall;

public class VisitorOpsFunction extends SpirvBaseVisitor<Void> {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();

    private final ProgramBuilderSpv builder;
    private String currentId;
    private FunctionType currentType;
    private List<String> currentArgs;

    public VisitorOpsFunction(ProgramBuilderSpv builder) {
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
            if (returnType.equals(fType.getReturnType())) {
                currentId = id;
                currentType = fType;
                currentArgs = new ArrayList<>();
                if (currentType.getParameterTypes().isEmpty()) {
                    createFunction();
                }
                return null;
            }
            throw new ParsingException("Failed to create function '%s'. " +
                    "Illegal return type: expected %s but received %s",
                    id, fType.getReturnType().getClass().getSimpleName(),
                    returnType.getClass().getSimpleName());
        }
        throw new ParsingException("Failed to create function '%s'. " +
                "Illegal variable type '%s': expected %s but received %s",
                id, typeName, FunctionType.class.getSimpleName(),
                type.getClass().getSimpleName());
    }

    @Override
    public Void visitOpFunctionParameter(SpirvParser.OpFunctionParameterContext ctx) {
        String id = ctx.idResult().getText();
        if (currentId != null && currentType != null && currentArgs != null) {
            String typeName = ctx.idResultType().getText();
            Type type = builder.getType(typeName);
            List<Type> argTypes = currentType.getParameterTypes();
            int idx = currentArgs.size();
            if (idx < argTypes.size() && type.equals(argTypes.get(idx))) {
                if (!currentArgs.contains(id)) {
                    currentArgs.add(id);
                    builder.addStorageClassForExpr(id, typeName);
                    if (currentArgs.size() == currentType.getParameterTypes().size()) {
                        createFunction();
                    }
                    return null;
                }
                throw new ParsingException("Duplicated parameter id '%s' in function '%s'",
                        id, currentId);
            }
            throw new ParsingException("Mismatching argument type in function '%s' " +
                    "for argument '%s'", currentId, id);
        }
        throw new ParsingException("Attempt to declare function parameter '%s' " +
                "outside of a function definition", id);
    }

    @Override
    public Void visitOpFunctionEnd(SpirvParser.OpFunctionEndContext ctx) {
        builder.endFunctionDefinition();
        return null;
    }

    @Override
    public Void visitOpFunctionCall(SpirvParser.OpFunctionCallContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        String functionId = ctx.function().getText();
        List<Expression> arguments = ctx.argument().stream()
                .map(a -> builder.getExpression(a.getText())).toList();
        Type returnType = builder.getType(typeId);
        List<Type> pTypes = arguments.stream().map(Expression::getType).toList();
        FunctionType functionType = TYPE_FACTORY.getFunctionType(builder.getType(typeId), pTypes);
        Function function = builder.getCalledFunction(functionId, functionType);
        Event event;
        if (returnType instanceof VoidType) {
            event = newVoidFunctionCall(function, arguments);
        } else {
            Register register = builder.addRegister(id, typeId);
            event = newValueFunctionCall(register, function, arguments);
        }
        builder.addEvent(event);
        return null;
    }

    private void createFunction() {
        builder.startFunctionDefinition(currentId, currentType, currentArgs);
        currentId = null;
        currentType = null;
        currentArgs = null;
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
