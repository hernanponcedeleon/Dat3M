package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;

import java.util.List;
import java.util.Set;

public class VisitorOpsType extends SpirvBaseVisitor<Type> {

    // TODO: Validate that size is a multiple of 8 + tests

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();

    private final ProgramBuilderSpv builder;

    public VisitorOpsType(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Type visitOp(SpirvParser.OpContext ctx) {
        Type type = ctx.getChild(0).accept(this);
        if (type != null) {
            return type;
        }
        throw new ParsingException("Cannot parse operation '%s'", ctx.getText());
    }

    @Override
    public Type visitOpTypeVoid(SpirvParser.OpTypeVoidContext ctx) {
        return builder.addType(ctx.idResult().getText(), TYPE_FACTORY.getVoidType());
    }

    @Override
    public Type visitOpTypeBool(SpirvParser.OpTypeBoolContext ctx) {
        return builder.addType(ctx.idResult().getText(), TYPE_FACTORY.getBooleanType());
    }

    @Override
    public Type visitOpTypeInt(SpirvParser.OpTypeIntContext ctx) {
        // TODO: Signedness
        String id = ctx.idResult().getText();
        int size = Integer.parseInt(ctx.widthLiteralInteger().getText());
        Type type = TYPE_FACTORY.getIntegerType(size);
        return builder.addType(id, type);
    }

    @Override
    public Type visitOpTypeVector(SpirvParser.OpTypeVectorContext ctx) {
        String id = ctx.idResult().getText();
        String elementTypeName = ctx.componentType().getText();
        Type elementType = builder.getType(elementTypeName);
        int size = Integer.parseInt(ctx.componentCount().getText());
        Type type = TYPE_FACTORY.getArrayType(elementType, size);
        return builder.addType(id, type);
    }

    @Override
    public Type visitOpTypeArray(SpirvParser.OpTypeArrayContext ctx) {
        String id = ctx.idResult().getText();
        String elementTypeName = ctx.elementType().getText();
        Type elementType = builder.getType(elementTypeName);
        String lengthValueName = ctx.length().getText();
        Expression lengthExpr = builder.getExpression(lengthValueName);
        if (lengthExpr != null) {
            if (lengthExpr instanceof IntLiteral iValue) {
                Type type = TYPE_FACTORY.getArrayType(elementType, iValue.getValue().intValue());
                return builder.addType(id, type);
            }
            throw new ParsingException("Attempt to use a non-integer value as array size '%s'", lengthValueName);
        }
        throw new ParsingException("Reference to undefined expression '%s'", lengthValueName);
    }

    @Override
    public Type visitOpTypeRuntimeArray(SpirvParser.OpTypeRuntimeArrayContext ctx) {
        String id = ctx.idResult().getText();
        String elementTypeName = ctx.elementType().getText();
        Type elementType = builder.getType(elementTypeName);
        Type type = TYPE_FACTORY.getArrayType(elementType);
        return builder.addType(id, type);
    }

    @Override
    public Type visitOpTypeStruct(SpirvParser.OpTypeStructContext ctx) {
        String id = ctx.idResult().getText();
        List<Type> memberTypes = ctx.memberType().stream()
                .map(memberCtx -> builder.getType(memberCtx.getText())).toList();
        Type type = TYPE_FACTORY.getAggregateType(memberTypes);
        return builder.addType(id, type);
    }

    @Override
    public Type visitOpTypePointer(SpirvParser.OpTypePointerContext ctx) {
        String id = ctx.idResult().getText();
        String inner = ctx.type().getText();
        String storageClass = ctx.storageClass().getText();
        return builder.addPointerType(id, inner, storageClass);
    }

    @Override
    public Type visitOpTypeFunction(SpirvParser.OpTypeFunctionContext ctx) {
        String id = ctx.idResult().getText();
        String returnTypeName = ctx.returnType().getText();
        Type returnType = builder.getType(returnTypeName);
        List<Type> argTypes = ctx.parameterType().stream()
                .map(argCtx -> builder.getType(argCtx.getText())).toList();
        Type type = TYPE_FACTORY.getFunctionType(returnType, argTypes);
        return builder.addType(id, type);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpTypeVoid",
                "OpTypeBool",
                "OpTypeInt",
                "OpTypeVector",
                "OpTypeArray",
                "OpTypeRuntimeArray",
                "OpTypeStruct",
                "OpTypePointer",
                "OpTypeFunction"
        );
    }
}
