package com.dat3m.dartagnan.expression.type;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.base.Preconditions;

import java.math.BigInteger;

public class IntegerType implements Type {

    private final int bitWidth;

    IntegerType(int bitWidth) {
        Preconditions.checkArgument(bitWidth > 0, "Invalid size for integers: %s", bitWidth);
        this.bitWidth = bitWidth;
    }

    public int getBitWidth() {
        return bitWidth;
    }

    public boolean canContain(BigInteger value) {
        if (value.signum() >= 0) {
            // check for upper bound for unsigned value
            final BigInteger upperBoundExclusive = BigInteger.TWO.pow(bitWidth);
            return value.compareTo(upperBoundExclusive) < 0; // value < 2^(bitWidth)
        } else {
            // check for lower bound for signed values
            final BigInteger lowerBoundInclusive = BigInteger.TWO.pow(bitWidth - 1).negate();
            return value.compareTo(lowerBoundInclusive) >= 0; // value >= -2^(bitWidth - 1) (1 bit is used for the sign)
        }
    }

    public BigInteger getMaximumValue(boolean signed) {
        return BigInteger.ONE.shiftLeft(signed ? bitWidth - 1 : bitWidth).subtract(BigInteger.ONE);
    }

    public BigInteger getMinimumValue(boolean signed) {
        return signed ? BigInteger.ONE.shiftLeft(bitWidth - 1).negate() : BigInteger.ZERO;
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
        return "bv" + bitWidth;
    }
}
