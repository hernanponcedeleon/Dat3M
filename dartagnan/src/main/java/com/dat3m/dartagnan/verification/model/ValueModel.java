package com.dat3m.dartagnan.verification.model;

import java.math.BigInteger;


// This class currently only serves as a representation of values in ExecutionModelNext,
// in order to avoid the type conversion at value extraction.
public class ValueModel {
    private final Object value;
    private final Type type;

    public enum Type {
        INTEGER, BOOLEAN
    }

    public ValueModel(Object literal) {
        if (literal == null) {
            value = null;
            type = null;
        } else if (literal instanceof BigInteger) {
            value = literal;
            type = Type.INTEGER;
        } else if (literal instanceof Boolean) {
            value = literal;
            type = Type.BOOLEAN;
        } else {
            throw new IllegalArgumentException("Unsupported value type: " + literal.getClass());
        }
    }

    public Object getValue() {
        return value;
    }

    public Type getType() {
        return type;
    }

    @Override
    public String toString() {
        return String.valueOf(value);
    }
}