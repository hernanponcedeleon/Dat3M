package com.dat3m.dartagnan.expression.aggregates;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.google.common.collect.ImmutableList;

public final class InsertExpr extends BinaryExpressionBase<Type, ExpressionKind.Other> {

    private final ImmutableList<Integer> indices;

    public InsertExpr(Expression aggregate, Iterable<Integer> indices, Expression value) {
        super(aggregate.getType(), ExpressionKind.Other.INSERT, aggregate, value);
        ExpressionHelper.checkSameType(ExpressionHelper.extractType(aggregate.getType(), indices), value.getType());
        this.indices = ImmutableList.copyOf(indices);
    }

    public ImmutableList<Integer> getIndices() { return indices; }

    public Expression getAggregate() { return left; }
    public Expression getInsertedValue() { return right; }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitInsertExpression(this);
    }
}
