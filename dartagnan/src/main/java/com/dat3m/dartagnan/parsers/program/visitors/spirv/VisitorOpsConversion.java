package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Local;

import java.util.Set;

public class VisitorOpsConversion extends SpirvBaseVisitor<Void> {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final ProgramBuilder builder;

    public VisitorOpsConversion(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Void visitOpBitcast(SpirvParser.OpBitcastContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        String operand = ctx.operand().getText();
        Type resultType = builder.getType(typeId);
        Expression operandExpr = builder.getExpression(operand);
        Type operandType = operandExpr.getType();

        if (resultType instanceof ArrayType || operandType instanceof ArrayType ||
                (operandType instanceof ScopedPointerType pointerType && pointerType.getPointedType() instanceof ArrayType)) {
            // TODO: Support bitcast between arrays
            throw new ParsingException("Bitcast between arrays is not supported for id '%s'", id);
        }

        if (resultType instanceof ScopedPointerType pointerType1 && operandType instanceof ScopedPointerType pointerType2
                && !(pointerType1.getScopeId().equals(pointerType2.getScopeId()))) {
                throw new ParsingException("Storage class mismatch in OpBitcast between '%s' and '%s' for id '%s'", typeId, operand, id);
        }

        Expression convertedExpr = expressions.makeCast(operandExpr, resultType);
        Register reg = builder.addRegister(id, typeId);
        builder.addEvent(EventFactory.newLocal(reg, convertedExpr));
        return null;
    }

    @Override
    public Void visitOpConvertPtrToU(SpirvParser.OpConvertPtrToUContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        if (!(builder.getType(typeId) instanceof IntegerType)) {
            throw new ParsingException("Type '%s' is not an integer type for id '%s'", typeId, id);
        }
        Expression pointerExpr = builder.getExpression(ctx.pointer().getText());
        Expression convertedPointer = expressions.makeCast(pointerExpr, builder.getType(typeId), false);
        Register reg = builder.addRegister(id, typeId);
        builder.addEvent(EventFactory.newLocal(reg, convertedPointer));
        return null;
    }

    @Override
    public Void visitOpConvertUToPtr(SpirvParser.OpConvertUToPtrContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        if (!(builder.getType(typeId) instanceof ScopedPointerType)) {
            throw new ParsingException("Type '%s' is not a pointer type for id '%s'", typeId, id);
        }
        Expression integerExpr = builder.getExpression(ctx.integerValue().getText());
        Expression convertedInteger = expressions.makeCast(integerExpr, builder.getType(typeId), false);
        Register reg = builder.addRegister(id, typeId);
        builder.addEvent(EventFactory.newLocal(reg, convertedInteger));
        return null;
    }

    @Override
    public Void visitOpPtrCastToGeneric(SpirvParser.OpPtrCastToGenericContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        if (!(builder.getType(typeId) instanceof ScopedPointerType genericType)) {
            throw new ParsingException("Type '%s' is not a pointer type for id '%s'", typeId, id);
        }
        if (!genericType.getScopeId().equals(Tag.Spirv.SC_GENERIC)) {
            throw new ParsingException("Invalid storage class '%s' for OpPtrCastToGeneric for id '%s'", genericType.getScopeId(), id);
        }
        String pointerId = ctx.pointer().getText();
        Expression pointer = builder.getExpression(pointerId);
        if (!(pointer.getType() instanceof ScopedPointerType pointerType)) {
            throw new ParsingException("Type '%s' is not a pointer type for id '%s'", pointerId, id);
        }
        String pointerSC = pointerType.getScopeId();
        Set<String> supportedSC = Set.of(
                Tag.Spirv.SC_CROSS_WORKGROUP,
                Tag.Spirv.SC_WORKGROUP,
                Tag.Spirv.SC_FUNCTION);
        if (!supportedSC.contains(pointerSC)) {
            throw new ParsingException("Invalid storage class '%s' for OpPtrCastToGeneric for id '%s'", pointerSC, id);
        }
        Expression convertedExpr = expressions.makeCast(pointer, genericType);
        Register reg = builder.addRegister(id, typeId);
        builder.addEvent(EventFactory.newLocal(reg, convertedExpr));
        return null;
    }

    @Override
    public Void visitOpUConvert(SpirvParser.OpUConvertContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        Expression operandExpr = builder.getExpression(ctx.unsignedValue().getText());
        convertAndAddLocal(typeId, id, operandExpr, false);
        return null;
    }

    @Override
    public Void visitOpSConvert(SpirvParser.OpSConvertContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        Expression operandExpr = builder.getExpression(ctx.signedValue().getText());
        convertAndAddLocal(typeId, id, operandExpr, true);
        return null;
    }

    private void convertAndAddLocal(String typeId, String id, Expression operandExpr, boolean isSigned) {
        Type targetType = builder.getType(typeId);
        Type operandType = operandExpr.getType();
        if (!(targetType instanceof IntegerType) || !(operandType instanceof IntegerType)) {
            // TODO: Support conversion between arrays
            throw new ParsingException("Unsupported conversion to type '%s' for id '%s'", typeId, id);
        }
        Expression convertedExpr = expressions.makeCast(operandExpr, targetType, isSigned);
        Register reg = builder.addRegister(id, typeId);
        builder.addEvent(EventFactory.newLocal(reg, convertedExpr));
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpBitcast",
                "OpConvertPtrToU",
                "OpConvertUToPtr",
                "OpPtrCastToGeneric",
                "OpUConvert",
                "OpSConvert"
        );
    }
}
