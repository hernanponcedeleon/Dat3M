package com.dat3m.dartagnan.expression.base;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.LeafExpression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.event.common.NoInterface;
import com.google.common.collect.ImmutableList;

@NoInterface
public abstract class LeafExpressionBase<TType extends Type> extends ExpressionBase<TType> implements LeafExpression {

    protected LeafExpressionBase(TType type) {
        super(type);
    }

    @Override
    public ImmutableList<Expression> getOperands() { return ImmutableList.of(); }

    @Override
    public int hashCode() {
        return System.identityHashCode(this);
    }

    @Override
    public boolean equals(Object obj) {
        return this == obj;
    }
}
