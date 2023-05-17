package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.expression.type.BooleanType;
import com.dat3m.dartagnan.program.expression.type.IntegerType;
import com.dat3m.dartagnan.program.expression.type.NumberType;
import com.dat3m.dartagnan.program.expression.type.Type;

import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Preconditions.checkState;

import java.math.BigInteger;

/**
 * Immutable constant integer values.
 */
public final class Literal extends AbstractExpression {

    private static final BigInteger minInt = BigInteger.valueOf(Integer.MIN_VALUE);
    private static final BigInteger maxInt = BigInteger.valueOf(Integer.MAX_VALUE);

    private final BigInteger value;

    Literal(BigInteger value, Type type) {
        super(type);
        this.value = checkNotNull(value);
    }

    public BigInteger getValue() {
        return value;
    }

    public int getValueAsInt() {
        checkState(minInt.compareTo(value) <= 0 && value.compareTo(maxInt) <= 0, "Non-int value %s.", value);
        return value.intValue();
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
        return this == o || o instanceof Literal && value.equals(((Literal)o).value) && type.equals(((Literal)o).type);
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
