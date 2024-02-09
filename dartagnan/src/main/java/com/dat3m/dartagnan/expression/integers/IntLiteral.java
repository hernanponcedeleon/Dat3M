package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LiteralExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.google.common.base.Preconditions;

import java.math.BigInteger;

/*
    Implementation note: This class represents values of fixed-size integer types using BigInteger.
    However, our integer types have no signedness but BigInteger does.
    This results in values that have their highest bit set to have non-unique representation,
    depending on whether that bit is treated as a sign-bit or not.
 */
public final class IntLiteral extends LiteralExpressionBase<IntegerType> {

    private final BigInteger value;

    public IntLiteral(IntegerType type, BigInteger value) {
        super(type);
        Preconditions.checkArgument(type.canContain(value));
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
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitIntLiteral(this);
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
