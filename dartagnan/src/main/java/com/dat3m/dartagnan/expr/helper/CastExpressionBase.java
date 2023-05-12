package com.dat3m.dartagnan.expr.helper;


import com.dat3m.dartagnan.expr.CastExpression;
import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.Type;

public abstract class CastExpressionBase<TType extends Type, TSourceType extends Type>
        extends UnaryExpressionBase<TType, ExpressionKind.Cast> implements CastExpression {

    protected CastExpressionBase(TType targetType, ExpressionKind.Cast kind, Expression operand) {
        super(targetType, kind, operand);
    }

    @SuppressWarnings("unchecked")
    public TSourceType getSourceType() { return (TSourceType) getOperand().getType(); }

    @Override
    public String toString() {
        return String.format("(%s)%s", getType(), getOperand());
    }
}
