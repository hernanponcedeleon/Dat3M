package com.dat3m.dartagnan.expr.helper;

import com.dat3m.dartagnan.expr.BinaryExpression;
import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.Type;

import java.util.List;

public abstract class BinaryExpressionBase<TType extends Type, TKind extends ExpressionKind>
        extends ExpressionBase<TType, TKind> implements BinaryExpression {

    protected BinaryExpressionBase(TType type, TKind kind, Expression left, Expression right) {
        super(type, kind, List.of(left, right));
    }

    @Override
    public String toString() {
        return String.format("(%s %s %s)", getLeft(), getKind().getSymbol(), getRight());
    }
}
