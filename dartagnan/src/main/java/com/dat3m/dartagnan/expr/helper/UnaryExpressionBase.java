package com.dat3m.dartagnan.expr.helper;

import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.expr.UnaryExpression;

import java.util.List;

public abstract class UnaryExpressionBase<TType extends Type, TKind extends ExpressionKind>
        extends ExpressionBase<TType, TKind> implements UnaryExpression {

    protected UnaryExpressionBase(TType type, TKind kind, Expression operand) {
        super(type, kind, List.of(operand));
    }

    @Override
    public String toString() {
        return String.format("%s%s", getKind().getSymbol(), getOperand());
    }
}
