package com.dat3m.dartagnan.task.exploration;

import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.*;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

/*
    Concrete values used by the exploration engine.
    - Integers, pointers and memory values are represented as unsigned-normalized BigIntegers.
    - Booleans are represented as Boolean.
    - Aggregates are represented as (immutable) lists of values.
 */
public final class Values {

    private Values() {}

    /*
        A nondeterministic value (e.g. from uninitialized variables). Such values may flow into registers,
        but exploration does not support computing with them (that would require branching over all values).
     */
    public static final Object UNDEFINED = new Object() {
        @Override
        public String toString() { return "undef"; }
    };

    private static UnsupportedOperationException undefinedUse() {
        return new UnsupportedOperationException(
                "Exploration does not support computations with nondeterministic (undefined) values.");
    }

    // Normalizes the value to the unsigned representation of the given width (i.e., modulo 2^width).
    public static BigInteger normalize(BigInteger value, int bitWidth) {
        if (value.signum() >= 0 && value.bitLength() <= bitWidth) {
            return value;
        }
        return value.mod(BigInteger.ONE.shiftLeft(bitWidth));
    }

    public static int bitWidth(Type type) {
        if (type instanceof IntegerType t) {
            return t.getBitWidth();
        }
        if (type instanceof MemoryType t) {
            return t.getBitWidth();
        }
        if (type instanceof BooleanType) {
            return 1;
        }
        throw new UnsupportedOperationException("Type " + type + " has no bit width");
    }

    public static Object zero(Type type) {
        if (type instanceof BooleanType) {
            return Boolean.FALSE;
        }
        if (type instanceof IntegerType || type instanceof MemoryType) {
            return BigInteger.ZERO;
        }
        if (type instanceof AggregateType aggType) {
            final List<Object> fields = new ArrayList<>();
            aggType.getFields().forEach(f -> fields.add(zero(f.type())));
            return List.copyOf(fields);
        }
        if (type instanceof ArrayType arrayType && arrayType.hasKnownNumElements()) {
            final List<Object> fields = new ArrayList<>();
            for (int i = 0; i < arrayType.getNumElements(); i++) {
                fields.add(zero(arrayType.getElementType()));
            }
            return List.copyOf(fields);
        }
        throw new UnsupportedOperationException("Cannot create zero value of type " + type);
    }

    public static BigInteger asInteger(Object value) {
        if (value == UNDEFINED) {
            throw undefinedUse();
        }
        if (value instanceof BigInteger i) {
            return i;
        }
        if (value instanceof Boolean b) {
            return b ? BigInteger.ONE : BigInteger.ZERO;
        }
        throw new UnsupportedOperationException("Value " + value + " is not an integer");
    }

    public static boolean asBoolean(Object value) {
        if (value == UNDEFINED) {
            throw undefinedUse();
        }
        if (value instanceof Boolean b) {
            return b;
        }
        if (value instanceof BigInteger i) {
            return i.signum() != 0;
        }
        throw new UnsupportedOperationException("Value " + value + " is not a boolean");
    }

    // Converts a value (e.g., read from memory) to the given type.
    public static Object convert(Object value, Type type) {
        if (value == UNDEFINED) {
            return UNDEFINED;
        }
        if (type instanceof BooleanType) {
            return asBoolean(value);
        }
        if (type instanceof IntegerType || type instanceof MemoryType) {
            if (value instanceof List<?>) {
                throw new UnsupportedOperationException("Cannot convert aggregate value to " + type);
            }
            return Values.normalize(asInteger(value), bitWidth(type));
        }
        return value;
    }

    public static String toString(Object value) {
        return value == null ? "?" : value.toString();
    }
}
