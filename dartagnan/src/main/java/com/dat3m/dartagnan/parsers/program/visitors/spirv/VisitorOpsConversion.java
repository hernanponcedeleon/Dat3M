package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.floats.FloatLiteral;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTypes;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;

import java.util.ArrayList;
import java.util.List;
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
        builder.addEvent(new Local(reg, convertedExpr));
        return null;
    }

    @Override
    public Void visitOpCompositeInsert(SpirvParser.OpCompositeInsertContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        String compositeId = ctx.composite().getText();
        String objectId = ctx.object().getText();
        Type resultType = builder.getType(typeId);
        Expression compositeExpr = builder.getExpression(compositeId);
        Expression objectExpr = builder.getExpression(objectId);
        Type compositeType = compositeExpr.getType();

        if (!compositeType.equals(resultType)) {
            throw new ParsingException("Type mismatch in OpCompositeInsert, " +
                    "result '%s' and composite '%s' must be the same for id '%s'", typeId, compositeId, id);
        }

        List<Integer> intIndexes = new ArrayList<>();
        ctx.indexesLiteralInteger().forEach(c -> {
            int index = Integer.parseInt(c.getText());
            intIndexes.add(index);
        });

        Type memberType = HelperTypes.getMemberType(id, compositeType, intIndexes);
        if (!memberType.equals(objectExpr.getType())) {
            throw new ParsingException("Type mismatch in OpCompositeInsert, " +
                    "object '%s' and member '%s' must be the same for id '%s'", objectId, compositeId, id);
        }

        Expression copy = copyCompositeAndInsert(compositeExpr, objectExpr, intIndexes, typeId);
        builder.addExpression(id, copy);
        return null;
    }

    private Expression copyCompositeAndInsert(Expression compositeExpr, Expression objectExpr, List<Integer> indexes, String typeId) {
        if (indexes.isEmpty()) {
            return objectExpr;
        }
        if (compositeExpr instanceof ConstructExpr constructExpr) {
            List<Expression> items = new ArrayList<>();
            int index = indexes.get(0);
            for (int i = 0; i < constructExpr.getOperands().size(); i++) {
                Expression item = constructExpr.getOperands().get(i);
                if (i == index) {
                    items.add(copyCompositeAndInsert(item, objectExpr, indexes.subList(1, indexes.size()), typeId));
                } else {
                    items.add(copyElement(item));
                }
            }
            return expressions.makeConstruct(constructExpr.getType(), items);
        } else {
            throw new ParsingException("Unsupported type '%s' for OpCompositeInsert", compositeExpr.getType());
        }
    }

    private Expression copyElement(Expression element) {
        if (element instanceof IntLiteral) {
            return expressions.makeValue((((IntLiteral) element).getValueAsInt()), (IntegerType) element.getType());
        } else if (element instanceof FloatLiteral) {
            return expressions.makeValue((((FloatLiteral) element).getValue()), (FloatType) element.getType());
        } else if (element instanceof ConstructExpr constructExpr) {
            List<Expression> items = new ArrayList<>();
            for (int i = 0; i < ((ArrayType) element.getType()).getNumElements(); i++) {
                items.add(copyElement(constructExpr.getOperands().get(i)));
            }
            return expressions.makeConstruct(constructExpr.getType(), items);
        } else if (element instanceof Register reg) {
            return reg;
        } else {
            throw new ParsingException("Unsupported type '%s' for OpCompositeInsert", element.getType());
        }
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
        builder.addEvent(new Local(reg, convertedPointer));
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

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpBitcast",
                "OpCompositeInsert",
                "OpConvertPtrToU",
                "OpPtrCastToGeneric"
        );
    }
}
