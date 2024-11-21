package com.dat3m.dartagnan.expression.aggregates;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;

public final class AggregateCmpExpr extends BinaryExpressionBase<BooleanType, AggregateCmpOp> {

    public AggregateCmpExpr(BooleanType type, Expression left, AggregateCmpOp kind, Expression right) {
        super(type, kind, left, right);
        ExpressionHelper.checkSameExpectedType(left, right, AggregateType.class);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitAggregateCmpExpression(this);
    }
}