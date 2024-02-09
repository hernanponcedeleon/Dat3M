package com.dat3m.dartagnan.expression.base;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.event.common.NoInterface;

@NoInterface
public abstract class LiteralExpressionBase<TType extends Type> extends LeafExpressionBase<TType> {

    protected LiteralExpressionBase(TType type) {
        super(type);
    }

    @Override
    public ExpressionKind.Other getKind() { return ExpressionKind.Other.LITERAL; }
}
