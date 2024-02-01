package com.dat3m.dartagnan.expression.base;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.event.common.NoInterface;

import java.util.List;

@NoInterface
public abstract class NaryExpressionBase<TType extends Type, TKind extends ExpressionKind> extends ExpressionBase<TType> {

    protected final List<Expression> operands;
    protected final TKind kind;

    protected NaryExpressionBase(TType type, TKind kind, List<Expression> operands) {
        super(type);
        this.operands = operands;
        this.kind = kind;
    }

    @Override
    public TType getType() { return this.type; }

    @Override
    public TKind getKind() {
        return kind;
    }

    @Override
    public List<Expression> getOperands() {
        return operands;
    }
}
