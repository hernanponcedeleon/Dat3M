package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.base.LiteralExpressionBase;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;

import java.math.BigInteger;

public final class IntLiteral extends LiteralExpressionBase<IntegerType> {

    private final BigInteger value;

    public IntLiteral(IntegerType type, BigInteger value) {
        super(type);
        this.value = value;
    }

    public BigInteger getValue() {
        return value;
    }

    public int getValueAsInt() {
        return value.intValueExact();
    }

    public boolean isOne() { return value.equals(BigInteger.ONE); }
    public boolean isZero() { return value.equals(BigInteger.ZERO); }

    @Override
    public IntLiteral reduce() {
        return this;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public int hashCode() {
        return getType().hashCode() ^ 0xa185f6b3 + value.hashCode();
    }

    @Override
    public boolean equals(Object o) {
        return this == o || o instanceof IntLiteral val && getType().equals(val.getType()) && value.equals(val.value);
    }

    @Override
    public String toString() {
        return String.format("%s(%s)", getType(), value);
    }
}
