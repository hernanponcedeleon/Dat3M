package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class FloatToIntCast extends CastExpressionBase<IntegerType, FloatType> {

    private final boolean isSigned;

    public FloatToIntCast(IntegerType targetType, Expression operand, boolean isSigned) {
        super(targetType, operand);
        ExpressionHelper.checkExpectedType(operand, FloatType.class);
        this.isSigned = isSigned;
    }

    public boolean isSigned() { return isSigned; }

    @Override
    public String toString() {
        final String opName = isSigned ? "fptosi" : "fptoui";
        return String.format("%s %s to %s", opName, operand, targetType);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitFloatToIntCastExpression(this);
    }
}
