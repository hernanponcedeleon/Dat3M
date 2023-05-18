package com.dat3m.dartagnan.prototype.expr.aggregates;

import com.dat3m.dartagnan.prototype.expr.Expression;
import com.dat3m.dartagnan.prototype.expr.ExpressionKind;
import com.dat3m.dartagnan.prototype.expr.ExpressionVisitor;
import com.dat3m.dartagnan.prototype.expr.helper.BinaryExpressionBase;
import com.dat3m.dartagnan.prototype.expr.types.AggregateType;
import com.google.common.base.Preconditions;

public class InsertValueExpression extends BinaryExpressionBase<AggregateType, ExpressionKind.Aggregates> {

    protected final int index;

    protected InsertValueExpression(int index, Expression aggregate, Expression insertValue) {
        super((AggregateType) aggregate.getType(), ExpressionKind.Aggregates.INSERT, aggregate, insertValue);
        this.index = index;
    }

    public Expression getAggregate() { return getLeft(); }
    public Expression getInsertValue() { return getRight(); }

    public static InsertValueExpression create(int index, Expression aggregate, Expression insertValue) {
        Preconditions.checkArgument(aggregate.getType() instanceof AggregateType);
        Preconditions.checkArgument(index >= 0);
        Preconditions.checkArgument(index <= ((AggregateType)aggregate.getType()).getAggregatedTypes().size());
        Preconditions.checkArgument(((AggregateType)aggregate.getType()).getAggregatedTypes().get(index) == insertValue.getType());
        return new InsertValueExpression(index, aggregate, insertValue);
    }

    @Override
    public String toString() {
        return String.format("%s(%d, %s, %s)", getKind().getSymbol(), index, getAggregate(), getInsertValue());
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitInsertValueExpression(this);
    }
}
