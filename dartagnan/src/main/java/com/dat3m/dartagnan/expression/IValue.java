package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

import static com.google.common.base.Preconditions.checkNotNull;

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
    public static IConst ZERO = new IValue(BigInteger.ZERO, TypeFactory.getInstance().getPointerType());
    public static IConst ONE = new IValue(BigInteger.ONE, TypeFactory.getInstance().getPointerType());

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
