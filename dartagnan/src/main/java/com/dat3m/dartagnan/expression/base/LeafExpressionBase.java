package com.dat3m.dartagnan.expression.base;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.common.NoInterface;
import com.google.common.collect.ImmutableSet;

import java.util.List;

@NoInterface
public abstract class LeafExpressionBase<TType extends Type, TKind extends ExpressionKind> extends ExpressionBase<TType> {

    protected LeafExpressionBase(TType type) {
        super(type);
    }

    @Override
    public List<Expression> getOperands() { return List.of(); }

    @Override
    public ImmutableSet<Register> getRegs() { return ImmutableSet.of(); }
}
