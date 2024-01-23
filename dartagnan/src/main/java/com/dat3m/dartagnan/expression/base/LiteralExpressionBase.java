package com.dat3m.dartagnan.expression.base;

import com.dat3m.dartagnan.expression.op.Kind;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.event.common.NoInterface;

@NoInterface
public abstract class LiteralExpressionBase<TType extends Type> extends LeafExpressionBase<TType, Kind> {

    protected LiteralExpressionBase(TType type) {
        super(type);
    }

    @Override
    public Kind getKind() { return Kind.LITERAL; }
}
