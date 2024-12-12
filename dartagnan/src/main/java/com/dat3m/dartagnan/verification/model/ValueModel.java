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
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }

        ValueModel vm = (ValueModel) other;
        if (value == null) {
            return vm.getValue() == null;
        }
        if (value.getClass() != vm.getValue().getClass()) {
            return false;
        }
        return value.equals(vm.getValue());
    }

    @Override
    public int hashCode() {
        return value == null ? 0 : value.hashCode();
    }

    @Override
    public String toString() {
        return String.valueOf(value);
    }
}