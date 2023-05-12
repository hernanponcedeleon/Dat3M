package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.expression.type.Type;

import static com.google.common.base.Preconditions.checkNotNull;

import java.math.BigInteger;

/**
 * Immutable constant integer values.
 */
public final class IValue extends IConst {

    private final BigInteger value;
    private final Type type;

    public IValue(BigInteger value, Type type) {
        this.value = checkNotNull(value);
        this.type = checkNotNull(type);
    }

    @Override
    public BigInteger getValue() {
        return value;
    }

    @Override
    public Type getType() {
        return type;
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public int hashCode() {
        return value.hashCode() + type.hashCode();
    }

    @Override
    public boolean equals(Object o) {
        return this == o || o instanceof IValue && value.equals(((IValue)o).value) && type.equals(((IValue)o).type);
    }

    @Override
    public String toString() {
        return value.toString();
    }
}
