package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;

public class FloatType implements Type {

    private final int mantissaBits;
    private final int exponentBits;

    FloatType(int mantissaBits, int exponentBits) {
        this.mantissaBits = mantissaBits;
        this.exponentBits = exponentBits;
    }

    public int getMantissaBits() {
        return mantissaBits;
    }

    public int getExponentBits() {
        return exponentBits;
    }

    public int getBitWidth() {
        return mantissaBits + exponentBits;
    }

    @Override
    public int hashCode() {
        return 127 * mantissaBits + exponentBits;
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof FloatType other
                && this.mantissaBits == other.mantissaBits
                && this.exponentBits == other.exponentBits);
    }

    @Override
    public String toString() {
        return String.format("float%s", getBitWidth());
    }
}
