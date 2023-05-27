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

    // TODO(TH): not sure where this are used, but why do you set the precision to 0?
    // TH: This was a temporary try for integer logic only
    // However, it is impossible to define general constants, we need a function that produces
    // a constant for each precision degree
    // HP: agree. I assume you wanted this to improve code readability, but having one constant per precision won't help.
    public static IConst ZERO = new IValue(BigInteger.ZERO, types.getArchType());
    public static IConst ONE = new IValue(BigInteger.ONE, types.getArchType());

    private final BigInteger value;

    @Deprecated
    public IValue(BigInteger v, int p) {
        this(v, p == -1 ? types.getIntegerType() : types.getIntegerType(p));
    }

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
