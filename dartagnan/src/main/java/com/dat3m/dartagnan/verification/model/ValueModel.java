package com.dat3m.dartagnan.verification.model;

import java.math.BigInteger;


// This class currently only serves as a representation of values in ExecutionModelNext,
// in order to avoid the type conversion at value extraction.
public class ValueModel {
    private final Object value;

    public ValueModel(Object literal) {
        if (literal == null) {
            value = null;
        } else if (literal instanceof BigInteger || literal instanceof Boolean) {
            value = literal;
        } else {
            throw new IllegalArgumentException("Unsupported value type: " + literal.getClass());
        }
    }

    public Object getValue() {
        return value;
    }

    @Override
    public String toString() {
        return String.valueOf(value);
    }
}