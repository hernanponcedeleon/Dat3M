package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;

import java.math.BigInteger;

/**
 * Immutable constant integer values.
 */
public final class IValue extends IExpr {

    private final BigInteger value;

    public IValue(BigInteger value, IntegerType type) {
        super(type);
        this.value = value;
    }

    public BigInteger getValue() {
        return value;
    }

    public int getValueAsInt() {
        return getValue().intValue();
    }

    public boolean isOne() { return value.equals(BigInteger.ONE); }
    public boolean isZero() { return value.equals(BigInteger.ZERO); }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public IValue reduce() {
        return this;
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
        return String.format("%s(%s)", getType(), value);
    }
}
