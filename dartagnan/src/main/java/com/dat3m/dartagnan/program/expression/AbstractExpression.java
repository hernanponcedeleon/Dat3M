package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.program.expression.type.Type;

import static com.google.common.base.Preconditions.checkNotNull;

public abstract class AbstractExpression implements Expression {

    protected final Type type;

    protected AbstractExpression(Type type) {
        this.type = checkNotNull(type);
    }

    @Override
    public final Type getType() {
        return type;
    }
}
