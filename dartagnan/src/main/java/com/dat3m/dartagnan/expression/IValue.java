package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;

import java.math.BigInteger;

/**
 * Immutable constant integer values.
 */
public final class IValue extends IConst {

    // TODO(TH): not sure where this are used, but why do you set the precision to 0?
    // TH: This was a temporary try for integer logic only
    // However, it is impossible to define general constants, we need a function that produces
    // a constant for each precision degree
    // HP: agree. I assume you wanted this to improve code readability, but having one constant per precision won't help.
    public static IConst ZERO = new IValue(BigInteger.ZERO, -1);
    public static IConst ONE = new IValue(BigInteger.ONE, -1);

    private final BigInteger value;
    private final int precision;

    public IValue(BigInteger v, int p) {
        value = v;
        precision = p;
    }

    @Override
    public BigInteger getValue() {
        return value;
    }

    @Override
    public int getPrecision() {
        return precision;
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public int hashCode() {
        return value.hashCode() + precision > 0 ? 0 : precision;
    }

    @Override
    public boolean equals(Object o) {
        return this == o || o instanceof IValue && value.equals(((IValue)o).value) && precision == ((IValue)o).precision;
    }

    @Override
    public String toString() {
        return value.toString();
    }
}
