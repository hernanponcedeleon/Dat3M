package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.expression.type.BooleanType;
import com.dat3m.dartagnan.program.expression.type.IntegerType;
import com.dat3m.dartagnan.program.expression.type.NumberType;
import com.dat3m.dartagnan.program.expression.type.Type;

import static com.google.common.base.Preconditions.checkNotNull;

import java.math.BigInteger;

/**
 * Immutable constant integer values.
 */
public final class IValue extends IConst {

    private final BigInteger value;
    public IValue(BigInteger value, Type type) {
        super(type);
        this.value = checkNotNull(value);
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
        return value.hashCode() + type.hashCode();
    }

    @Override
    public boolean equals(Object o) {
        return this == o || o instanceof IValue && value.equals(((IValue)o).value) && type.equals(((IValue)o).type);
    }

    @Override
    public String toString() {
        if (type instanceof BooleanType) {
            return value.equals(BigInteger.ZERO) ? "false" : "true";
        }
        if (type instanceof NumberType) {
            return value.toString();
        }
        if (type instanceof IntegerType) {
            return value.toString() + "bv" + ((IntegerType) type).getBitWidth();
        }
        return type + "(" + value + ")";
    }
}
