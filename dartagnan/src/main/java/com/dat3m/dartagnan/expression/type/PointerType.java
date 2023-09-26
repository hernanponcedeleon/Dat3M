package com.dat3m.dartagnan.expression.type;

/**
 * Memory operations use expressions of this type for their address.
 */
public final class PointerType implements Type {

    private final int precision;

    PointerType(int p) {
        precision = p;
    }

    public int getBitWidth() {
        return precision;
    }

    @Override
    public String toString() {
        return "ptr";
    }
}
