package com.dat3m.dartagnan.prototype.expr.types;

import com.dat3m.dartagnan.prototype.expr.Type;
import com.dat3m.dartagnan.prototype.expr.integers.IntLiteral;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

public final class IntegerType implements Type {

    private static final Map<Integer, IntegerType> bitWidth2TypeMap = new HashMap<>();

    public static IntegerType get(int bitWidth) {
        Preconditions.checkArgument(bitWidth >= -1, "Only bit width >= -1 is allowed.");
        return bitWidth2TypeMap.computeIfAbsent(bitWidth, IntegerType::new);
    }

    public static final IntegerType MATH = get(-1);
    public static final IntegerType INT1 = get(1);
    public static final IntegerType INT8 = get(8);
    public static final IntegerType INT16 = get(16);
    public static final IntegerType INT32 = get(32);
    public static final IntegerType INT64 = get(64);

    public static IntegerType ARCH_DEFAULT = INT64;


    // Special value "-1" for mathematical integers
    private final int bitWidth;

    private IntegerType(int bitWidth) {
        this.bitWidth = bitWidth;
    }

    public int getBitWidth() {
        return this.bitWidth;
    }

    public boolean isUnbounded() {
        return this.bitWidth == -1;
    }

    public boolean isBounded() {
        return !isUnbounded();
    }

    public boolean canContain(IntegerType other) {
        return this.isUnbounded() || (other.isBounded() && this.bitWidth >= other.bitWidth);
    }

    public boolean canContain(BigInteger value) {
        if (this.isUnbounded()) {
            return true;
        } else if (value.signum() >= 0) {
            final BigInteger upperBoundExclusive = BigInteger.TWO.pow(this.getBitWidth());
            return value.compareTo(upperBoundExclusive) < 0; // value < 2^(bitWidth)
        } else {
            final BigInteger lowerBoundInclusive = BigInteger.TWO.pow(this.getBitWidth() - 1).negate();
            return value.compareTo(lowerBoundInclusive) >= 0; // value >= -2^(bitWidth - 1)   (1 bit is used for the sign)
        }
    }

    public IntLiteral createLiteral(BigInteger value) {
        return IntLiteral.create(this, value);
    }

    public IntLiteral createLiteral(long value) {
        return IntLiteral.create(this, value);
    }

    public BigInteger getMaximalValue(boolean isSigned) {
        Preconditions.checkState(isBounded(), "Mathematical integers have no maximal value.");
        return BigInteger.TWO.pow(isSigned ? bitWidth - 1 : bitWidth).subtract(BigInteger.ONE);
    }

    public BigInteger getMinimalValue(boolean isSigned) {
        Preconditions.checkState(isBounded() || !isSigned,
                "Signed mathematical integers have no minimal value");

        return !isSigned ? BigInteger.ZERO : BigInteger.TWO.pow(bitWidth).negate();
    }

    @Override
    public int getMemoryAlignment() {
        return 1 + (bitWidth - 1) / 8;
    }

    @Override
    public int getMemorySize() {
        int alignment = getMemoryAlignment();
        return alignment + (bitWidth - 1) / alignment * alignment;
    }

    @Override
    public int hashCode() {
        return bitWidth;
    }

    @Override
    public String toString() {
        return isUnbounded() ? "MathInt" : "Int" + this.bitWidth;
    }
}
