package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.List;
import java.util.Set;
import java.util.function.BiFunction;
import java.util.stream.IntStream;

public class VisitorOpsConversion extends SpirvBaseVisitor<Event> {

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final ProgramBuilder builder;

    public VisitorOpsConversion(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpBitcast(SpirvParser.OpBitcastContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        String operand = ctx.operand().getText();
        Type resultType = builder.getType(typeId);
        Expression operandExpr = builder.getExpression(operand);
        Type operandType = operandExpr.getType();

        if (resultType instanceof ArrayType || operandType instanceof ArrayType) {
            // TODO: Support bitcast between arrays
            throw new ParsingException("Bitcast between arrays is not supported for id '%s'", id);
        }

        if (resultType instanceof ScopedPointerType pointerType1 && operandType instanceof ScopedPointerType pointerType2
                && !(pointerType1.getScopeId().equals(pointerType2.getScopeId()))) {
                throw new ParsingException("Storage class mismatch in OpBitcast between '%s' and '%s' for id '%s'", typeId, operand, id);
        }

        Expression convertedExpr = expressions.makeCast(operandExpr, resultType);
        Register reg = builder.addRegister(id, typeId);
        return builder.addEvent(EventFactory.newLocal(reg, convertedExpr));
    }

    @Override
    public Event visitOpConvertFToU(SpirvParser.OpConvertFToUContext ctx) {
        return convertFloatToInt(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.floatValue().getText(), false);
    }

    @Override
    public Event visitOpConvertFToS(SpirvParser.OpConvertFToSContext ctx) {
        return convertFloatToInt(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.floatValue().getText(), true);
    }

    @Override
    public Event visitOpConvertSToF(SpirvParser.OpConvertSToFContext ctx) {
        return convertIntToFloat(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.signedValue().getText(), true);
    }

    @Override
    public Event visitOpConvertUToF(SpirvParser.OpConvertUToFContext ctx) {
        return convertIntToFloat(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.unsignedValue().getText(), false);
    }

    @Override
    public Event visitOpFConvert(SpirvParser.OpFConvertContext ctx) {
        return convertAndAddLocal(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.floatValue().getText(), FloatType.class, FloatType.class,
                (target, source) -> expressions.makeFloatCast(source, target, true));
    }

    private Event convertFloatToInt(String id, String typeId, String operandId, boolean isSigned) {
        return convertAndAddLocal(id, typeId, operandId, IntegerType.class, FloatType.class,
                (target, source) -> expressions.makeIntegerCast(source, target, isSigned));
    }

    private Event convertIntToFloat(String id, String typeId, String operandId, boolean isSigned) {
        return convertAndAddLocal(id, typeId, operandId, FloatType.class, IntegerType.class,
                (target, source) -> expressions.makeFloatCast(source, target, isSigned));
    }

    private <T extends Type> Expression convertComponents(
            String id,
            Type targetType,
            Expression operand,
            Class<T> targetElementClass,
            Class<? extends Type> sourceElementClass,
            BiFunction<T, Expression, Expression> conversion
    ) {
        if (targetElementClass.isInstance(targetType) && sourceElementClass.isInstance(operand.getType())) {
            return conversion.apply(targetElementClass.cast(targetType), operand);
        }
        if (targetType instanceof ArrayType targetArray
                && operand.getType() instanceof ArrayType sourceArray
                && targetArray.hasKnownNumElements()
                && sourceArray.hasKnownNumElements()
                && targetArray.getNumElements() == sourceArray.getNumElements()
                && targetElementClass.isInstance(targetArray.getElementType())
                && sourceElementClass.isInstance(sourceArray.getElementType())) {
            List<Expression> elements = IntStream.range(0, targetArray.getNumElements())
                    .mapToObj(index -> conversion.apply(targetElementClass.cast(targetArray.getElementType()),
                            getElement(operand, index)))
                    .toList();
            return expressions.makeArray(targetArray, elements);
        }
        throw new ParsingException("Illegal conversion for '%s' from '%s' to '%s'", id, operand.getType(), targetType);
    }

    private Expression getElement(Expression expression, int index) {
        return expression instanceof ConstructExpr
                ? expression.getOperands().get(index)
                : expressions.makeExtract(expression, index);
    }

    @Override
    public Event visitOpConvertPtrToU(SpirvParser.OpConvertPtrToUContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        Expression pointer = builder.getExpression(ctx.pointer().getText());
        if (type instanceof ScopedPointerType || !(type instanceof IntegerType)) {
            throw new ParsingException("Illegal OpConvertPtrToU for '%s', " +
                    "attempt to convent into a non-integer type", id);
        }
        if (!(pointer.getType() instanceof ScopedPointerType)) {
            throw new ParsingException("Illegal OpConvertPtrToU for '%s', " +
                    "attempt to apply conversion on a non-pointer type", id);
        }
        Expression convertedPointer = expressions.makeCast(pointer, type, false);
        Register register = builder.addRegister(id, type);
        return builder.addEvent(EventFactory.newLocal(register, convertedPointer));
    }

    @Override
    public Event visitOpConvertUToPtr(SpirvParser.OpConvertUToPtrContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        Expression value = builder.getExpression(ctx.integerValue().getText());
        if (!(type instanceof ScopedPointerType)) {
            throw new ParsingException("Illegal OpConvertUToPtr for '%s', " +
                    "attempt to convent into a non-pointer type", id);
        }
        if (value.getType() instanceof ScopedPointerType
                || !(value.getType() instanceof IntegerType)) {
            throw new ParsingException("Illegal OpConvertUToPtr for '%s', " +
                    "attempt to apply conversion on a non-integer value", id);
        }
        Expression pointer = expressions.makeCast(value, type, false);
        Register register = builder.addRegister(id, type);
        return builder.addEvent(EventFactory.newLocal(register, pointer));
    }

    @Override
    public Event visitOpPtrCastToGeneric(SpirvParser.OpPtrCastToGenericContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        Expression oldPointer = builder.getExpression(ctx.pointer().getText());
        if (!(type instanceof ScopedPointerType newType)
                || !(oldPointer.getType() instanceof ScopedPointerType oldType)) {
            throw new ParsingException("Illegal OpPointerCastToGeneric for '%s', " +
                    "attempt to apply cast to a non-pointer", id);
        }
        if (!newType.getPointedType().equals(oldType.getPointedType())) {
            throw new ParsingException("Illegal OpPointerCastToGeneric for '%s', " +
                    "result and original pointers point to different types", id);
        }
        if (!newType.getScopeId().equals(Tag.Spirv.SC_GENERIC)) {
            throw new ParsingException("Illegal OpPointerCastToGeneric for '%s', " +
                    "attempt to cast into a non-generic pointer", id);
        }
        Expression newPointer = expressions.makeScopedPointer(id, newType, oldPointer);
        builder.addExpression(id, newPointer);
        return null;
    }

    @Override
    public Event visitOpUConvert(SpirvParser.OpUConvertContext ctx) {
        return convertAndAddLocal(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.unsignedValue().getText(), IntegerType.class, IntegerType.class,
                (target, source) -> expressions.makeIntegerCast(source, target, false));
    }

    @Override
    public Event visitOpSConvert(SpirvParser.OpSConvertContext ctx) {
        return convertAndAddLocal(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.signedValue().getText(), IntegerType.class, IntegerType.class,
                (target, source) -> expressions.makeIntegerCast(source, target, true));
    }

    private <T extends Type> Event convertAndAddLocal(
            String id,
            String typeId,
            String operandId,
            Class<T> targetElementClass,
            Class<? extends Type> sourceElementClass,
            BiFunction<T, Expression, Expression> conversion
    ) {
        Type targetType = builder.getType(typeId);
        Expression operand = builder.getExpression(operandId);
        Expression converted = convertComponents(id, targetType, operand, targetElementClass,
                sourceElementClass, conversion);
        Register register = builder.addRegister(id, targetType);
        return builder.addEvent(EventFactory.newLocal(register, converted));
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpBitcast",
                "OpConvertFToU",
                "OpConvertFToS",
                "OpConvertSToF",
                "OpConvertUToF",
                "OpFConvert",
                "OpConvertPtrToU",
                "OpConvertUToPtr",
                "OpPtrCastToGeneric",
                "OpUConvert",
                "OpSConvert"
        );
    }
}
