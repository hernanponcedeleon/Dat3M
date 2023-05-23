package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.program.expression.type.BooleanType;
import com.dat3m.dartagnan.program.expression.type.Type;

import java.math.BigInteger;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Immutable constant integer values.
 */
public final class Literal extends AbstractExpression {

    private final BigInteger value;

    Literal(BigInteger value, Type type) {
        super(type);
        this.value = checkNotNull(value);
    }

    public BigInteger getValue() {
        return value;
    }

    public int getValueAsInt() {
        return value.intValueExact();
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
        final String typeString;
        final String valueString;
        if (type instanceof BooleanType) {
            typeString = type.toString();
            valueString = value.equals(BigInteger.ZERO) ? "false" : "true";
        } else {
            typeString = type.toString();
            valueString = value.toString();
        }

        return typeString + " " + valueString;
    }
}
