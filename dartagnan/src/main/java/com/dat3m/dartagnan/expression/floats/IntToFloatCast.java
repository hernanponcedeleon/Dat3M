package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.CastExpressionBase;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class IntToFloatCast extends CastExpressionBase<FloatType, IntegerType> {

    private final boolean isSigned;

    public IntToFloatCast(FloatType targetType, Expression operand, boolean isSigned) {
        super(targetType, operand);
        ExpressionHelper.checkExpectedType(operand, IntegerType.class);
        this.isSigned = isSigned;
    }

    public boolean isSigned() { return isSigned; }

    @Override
    public String toString() {
        final String opName = isSigned ? "sitofp" : "uitofp";
        return String.format("%s %s to %s", opName, operand, targetType);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntToFloatCastExpression(this);
    }
}
