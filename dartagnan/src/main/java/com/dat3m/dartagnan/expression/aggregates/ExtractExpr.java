package com.dat3m.dartagnan.expression.aggregates;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.UnaryExpressionBase;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.collect.ImmutableList;

public final class ExtractExpr extends UnaryExpressionBase<Type, ExpressionKind.Other> {

    private final ImmutableList<Integer> indices;

    public ExtractExpr(Expression expr, Iterable<Integer> indices) {
        super(ExpressionHelper.extractType(expr.getType(), indices), ExpressionKind.Other.EXTRACT, expr);
        this.indices = ImmutableList.copyOf(indices);
    }

    public ImmutableList<Integer> getIndices() { return indices; }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitExtractExpression(this);
    }
}
