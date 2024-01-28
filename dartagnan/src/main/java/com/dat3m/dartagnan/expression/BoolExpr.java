package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.type.BooleanType;

import static com.google.common.base.Preconditions.checkNotNull;

public abstract class BoolExpr implements Expression {

    private final BooleanType type;

    protected BoolExpr(BooleanType type) {
        this.type = checkNotNull(type);
    }

    @Override
    public BooleanType getType() {
        return type;
    }
}
