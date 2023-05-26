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
    public static IConst ZERO = new IValue(types.getArchType(), BigInteger.ZERO);
    public static IConst ONE = new IValue(types.getArchType(), BigInteger.ONE);

    private final BigInteger value;
    private final IntegerType type;

    @Deprecated
    public IValue(BigInteger v, int p) {
        this(p == -1 ? types.getIntegerType() : types.getIntegerType(p), v);
    }

    public IValue(IntegerType t, BigInteger v) {
        type = t;
        value = v;
    }

    @Override
    public BigInteger getValue() {
        return value;
    }

    @Override
    public int getPrecision() {
        return type.isMathematical() ? -1 : type.getBitWidth();
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public int hashCode() {
        return type.hashCode() ^ 0xa185f6b3 + value.hashCode();
    }

    @Override
    public boolean equals(Object o) {
        return this == o || o instanceof IValue && type.equals(((IValue) o).type) && value.equals(((IValue) o).value);
    }

    @Override
    public String toString() {
        return value.toString() + type.toString();
    }
}
