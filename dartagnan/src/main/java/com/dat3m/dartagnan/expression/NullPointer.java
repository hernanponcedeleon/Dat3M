package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.PointerType;

import static com.google.common.base.Preconditions.checkNotNull;

public final class NullPointer implements Expression {

    private final PointerType type;

    public NullPointer(PointerType t) {
        type = checkNotNull(t);
    }

    @Override
    public PointerType getType() {
        return type;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return "nullptr";
    }
}
