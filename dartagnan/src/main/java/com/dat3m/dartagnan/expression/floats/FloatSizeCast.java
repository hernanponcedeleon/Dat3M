package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class FloatSizeCast extends CastExpressionBase<FloatType, FloatType> {

    public FloatSizeCast(FloatType targetType, Expression operand) {
        super(targetType, operand);
        ExpressionHelper.checkExpectedType(operand, FloatType.class);
    }

    public boolean isTruncation() {
        return isExtension(getTargetType(), getSourceType());
    }

    public boolean isExtension() {
        return isExtension(getSourceType(), getTargetType());
    }

    public boolean isNoop() {
        return getSourceType().equals(getTargetType());
    }

    private static boolean isExtension(FloatType sourceType, FloatType targetType) {
        return sourceType.getBitWidth() < targetType.getBitWidth();
    }

    @Override
    public String toString() {
        final String opName = isTruncation() ? "trunc" : "ext";
        return String.format("%s %s to %s", operand, opName, targetType);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitFloatSizeCastExpression(this);
    }
}
