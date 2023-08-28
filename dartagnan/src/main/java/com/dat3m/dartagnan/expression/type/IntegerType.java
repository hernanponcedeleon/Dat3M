package com.dat3m.dartagnan.expression.type;

import java.math.BigInteger;

import static com.google.common.base.Preconditions.checkState;

public final class IntegerType implements Type {

    final static int MATHEMATICAL = -1;

    private final int bitWidth;

    IntegerType(int bitWidth) {
        this.bitWidth = bitWidth;
    }

    public boolean isMathematical() {
        return bitWidth == MATHEMATICAL;
    }

    public int getBitWidth() {
        checkState(bitWidth > 0, "Invalid integer bound %s", bitWidth);
        return bitWidth;
    }

    public boolean canContain(BigInteger value) {
        // Both signed and unsigned versions are allowed.
        // The value range is the union of [ 0, 2^bitWidth ) and [ -2^(bitWidth-1), 2^(bitWidth-1) ).
        if (isMathematical()) {
            return true;
        } else if (value.signum() >= 0) {
            // check for upper bound for unsigned value
            final BigInteger upperBoundExclusive = BigInteger.TWO.pow(bitWidth);
            return value.compareTo(upperBoundExclusive) < 0; // value < 2^(bitWidth)
        } else {
            // check for lower bound for signed values
            final BigInteger lowerBoundInclusive = BigInteger.TWO.pow(bitWidth - 1).negate();
            return value.compareTo(lowerBoundInclusive) >= 0; // value >= -2^(bitWidth - 1) (1 bit is used for the sign)
        }
    }

    public BigInteger applySign(BigInteger value, boolean signed) {
        if (signed) {
            return value.testBit(bitWidth - 1) ? value.subtract(BigInteger.TWO.pow(bitWidth)) : value;
        }
        return value.signum() >= 0 ? value : BigInteger.TWO.pow(bitWidth).add(value);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        return obj instanceof IntegerType other && other.bitWidth == this.bitWidth;
    }

    @Override
    public int hashCode() {
        return 31 * bitWidth;
    }

    @Override
    public String toString() {
        return isMathematical() ? "int" : "bv" + bitWidth;
    }
}
