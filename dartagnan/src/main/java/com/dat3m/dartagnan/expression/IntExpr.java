package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.type.IntegerType;

import static com.google.common.base.Preconditions.checkNotNull;

public abstract class IntExpr implements Expression {

    private final IntegerType type;

    protected IntExpr(IntegerType type) {
        this.type = checkNotNull(type);
    }

    @Override
    public final IntegerType getType() {
        return type;
    }
}
