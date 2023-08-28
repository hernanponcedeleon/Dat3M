package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

import java.math.BigInteger;

/**
 * Immutable constant integer values.
 */
public final class IValue extends IConst {

    private static final TypeFactory types = TypeFactory.getInstance();

    private final BigInteger value;

    public IValue(BigInteger value, IntegerType type) {
        super(type);
        this.value = value;
    }

    @Override
    public BigInteger getValue() {
        return value;
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public int hashCode() {
        return getType().hashCode() ^ 0xa185f6b3 + value.hashCode();
    }

    @Override
    public boolean equals(Object o) {
        return this == o || o instanceof IValue val && getType().equals(val.getType()) && value.equals(val.value);
    }

    @Override
    public String toString() {
        return value.toString() + getType().toString();
    }
}
