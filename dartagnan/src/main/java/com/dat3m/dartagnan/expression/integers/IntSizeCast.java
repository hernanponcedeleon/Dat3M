package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class IntSizeCast extends CastExpressionBase<IntegerType, IntegerType> {

    private final boolean preserveSign;

    public IntSizeCast(IntegerType targetType, Expression operand, boolean preserveSign) {
        super(targetType, operand);
        ExpressionHelper.checkExpectedType(operand, IntegerType.class);
        this.preserveSign = (preserveSign && isExtension()) || isNoop();
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

    public boolean preservesSign() {
        return preserveSign;
    }

    private static boolean isExtension(IntegerType sourceType, IntegerType targetType) {
        return sourceType.getBitWidth() < targetType.getBitWidth();
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntSizeCastExpression(this);
    }
}
