package com.dat3m.dartagnan.expression.utils;

import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.function.BiFunction;

public class IntegerHelper {


    private IntegerHelper() { }

    public static BigInteger normalizeSigned(BigInteger value, int bitWidth) {
        return isSignedNormalized(value, bitWidth) ? value : value.subtract(BigInteger.ONE.shiftLeft(bitWidth));
    }

    public static boolean isSignedNormalized(BigInteger value, int bitWidth) {
        Preconditions.checkArgument(isRepresentable(value, bitWidth));
        return bitWidth < 0 || value.signum() <= 0 || !value.testBit(bitWidth - 1);
    }

    public static BigInteger normalizeUnsigned(BigInteger value, int bitWidth) {
        return isUnsignedNormalized(value, bitWidth) ? value : value.add(BigInteger.ONE.shiftLeft(bitWidth));
    }

    public static boolean isUnsignedNormalized(BigInteger value, int bitWidth) {
        Preconditions.checkArgument(isRepresentable(value, bitWidth));
        return bitWidth < 0 || value.signum() >= 0;
    }

    public static boolean isRepresentable(BigInteger value, int bitWidth) {
        if (bitWidth < 0) {
            return true;
        }
        return getNumRequiredBits(value) <= bitWidth;
    }

    public static int getNumRequiredBits(BigInteger value) {
        return value.bitLength() + (value.signum() >= 0 ? 0 : 1);
    }

    public static BigInteger truncate(BigInteger value, int targetBitWidth) {
        if (isRepresentable(value, targetBitWidth)) {
            return value;
        }
        final boolean isNegative = value.signum() < 0 && value.testBit(targetBitWidth - 1);
        return isNegative ? truncateSigned(value, targetBitWidth) : truncateUnsigned(value, targetBitWidth);
    }

    public static BigInteger truncateSigned(BigInteger value, int targetBitWidth) {
        return truncateAndNormalize(value, targetBitWidth, IntegerHelper::normalizeSigned);
    }

    public static BigInteger truncateUnsigned(BigInteger value, int targetBitWidth) {
        return truncateAndNormalize(value, targetBitWidth, IntegerHelper::normalizeUnsigned);
    }

    private static BigInteger truncateAndNormalize(BigInteger value, int targetBitWidth,
                                                   BiFunction<BigInteger, Integer, BigInteger> normalizer) {
        if (isRepresentable(value, targetBitWidth)) {
            return normalizer.apply(value, targetBitWidth);
        } else {
            final BigInteger mask = BigInteger.ONE.shiftLeft(targetBitWidth).subtract(BigInteger.ONE);
            return normalizer.apply(value.and(mask), targetBitWidth);
        }
    }

    public static BigInteger extend(BigInteger value, int sourceBitWidth, int targetBitWidth, boolean signed) {
        return signed ?
                signExtend(value, sourceBitWidth, targetBitWidth)
                : zeroExtend(value, sourceBitWidth, targetBitWidth);
    }

    public static BigInteger signExtend(BigInteger value, int sourceBitWidth, int targetBitWidth) {
        Preconditions.checkArgument(isRepresentable(value, sourceBitWidth));
        Preconditions.checkArgument(sourceBitWidth <= targetBitWidth);

        if (value.signum() <= 0 || sourceBitWidth == targetBitWidth || !value.testBit(sourceBitWidth - 1)) {
            return value;
        } else {
            final int numExtendedBits = targetBitWidth - sourceBitWidth;
            final BigInteger extendedBitsMask = BigInteger.ONE
                    .shiftLeft(numExtendedBits)
                    .subtract(BigInteger.ONE)
                    .shiftLeft(sourceBitWidth);
            return value.or(extendedBitsMask);
        }
    }

    public static BigInteger zeroExtend(BigInteger value, int sourceBitWidth, int targetBitWidth) {
        Preconditions.checkArgument(isRepresentable(value, sourceBitWidth));
        Preconditions.checkArgument(sourceBitWidth <= targetBitWidth);

        if (value.signum() >= 0 || sourceBitWidth == targetBitWidth) {
            return value;
        } else {
            final BigInteger mask = BigInteger.ONE.shiftLeft(sourceBitWidth).subtract(BigInteger.ONE);
            return value.and(mask);
        }
    }

    // -----------------------------------------------------------------------------------------------
    // ========================================= Operations  =========================================
    // -----------------------------------------------------------------------------------------------

    public static BigInteger add(BigInteger x, BigInteger y, int bitWidth) {
        return truncate(x.add(y), bitWidth);
    }

    public static BigInteger sub(BigInteger x, BigInteger y, int bitWidth) {
        return truncate(x.subtract(y), bitWidth);
    }

    public static BigInteger mul(BigInteger x, BigInteger y, int bitWidth) {
        return truncate(x.multiply(y), bitWidth);
    }

    public static BigInteger neg(BigInteger x, int bitWidth) {
        return truncate(x.negate(), bitWidth);
    }

    public static BigInteger sdiv(BigInteger x, BigInteger y, int bitWidth) {
        final BigInteger sx = normalizeSigned(x, bitWidth);
        final BigInteger sy = normalizeSigned(y, bitWidth);
        return normalizeSigned(sx.divide(sy), bitWidth);
    }

    public static BigInteger udiv(BigInteger x, BigInteger y, int bitWidth) {
        final BigInteger ux = normalizeUnsigned(x, bitWidth);
        final BigInteger uy = normalizeUnsigned(y, bitWidth);
        return normalizeUnsigned(ux.divide(uy), bitWidth);
    }

    public static BigInteger srem(BigInteger x, BigInteger y, int bitWidth) {
        final BigInteger sx = normalizeSigned(x, bitWidth);
        final BigInteger sy = normalizeSigned(y, bitWidth);
        return normalizeSigned(sx.remainder(sy), bitWidth);
    }

    public static BigInteger urem(BigInteger x, BigInteger y, int bitWidth) {
        final BigInteger ux = normalizeUnsigned(x, bitWidth);
        final BigInteger uy = normalizeUnsigned(y, bitWidth);
        return normalizeUnsigned(ux.remainder(uy), bitWidth);
    }

    // We use LLVM semantics: "y" is considered unsigned
    public static BigInteger lshift(BigInteger x, BigInteger y, int bitWidth) {
        y = normalizeUnsigned(y, bitWidth);
        return truncate(x.shiftLeft(y.intValueExact()), bitWidth);
    }

    // We use LLVM semantics: "y" is considered unsigned
    public static BigInteger rshift(BigInteger x, BigInteger y, int bitWidth) {
        x = normalizeUnsigned(x, bitWidth);
        y = normalizeUnsigned(y, bitWidth);
        return x.shiftRight(y.intValueExact());
    }

    // We use LLVM semantics: "y" is considered unsigned
    public static BigInteger arshift(BigInteger x, BigInteger y, int bitWidth) {
        y = normalizeUnsigned(y, bitWidth);
        return x.shiftRight(y.intValueExact());
    }

    public static BigInteger and(BigInteger x, BigInteger y, int bitWidth) {
        return x.and(y);
    }

    public static BigInteger or(BigInteger x, BigInteger y, int bitWidth) {
        return x.or(y);
    }

    public static BigInteger xor(BigInteger x, BigInteger y, int bitWidth) {
        return truncate(x.xor(y), bitWidth);
    }

    public static int scmp(BigInteger x, BigInteger y, int bitWidth) {
        final BigInteger sx = normalizeSigned(x, bitWidth);
        final BigInteger sy = normalizeSigned(y, bitWidth);
        return sx.compareTo(sy);
    }

    public static int ucmp(BigInteger x, BigInteger y, int bitWidth) {
        final BigInteger ux = normalizeUnsigned(x, bitWidth);
        final BigInteger uy = normalizeUnsigned(y, bitWidth);
        return ux.compareTo(uy);
    }

    public static boolean equals(BigInteger x, BigInteger y, int bitWidth) {
        Preconditions.checkArgument(isRepresentable(x, bitWidth));
        Preconditions.checkArgument(isRepresentable(y, bitWidth));

        return normalizeSigned(x, bitWidth).equals(normalizeSigned(y, bitWidth));
    }

    public static BigInteger ctlz(BigInteger x, int bitWidth) {
        int leadingZeroes = 0;
        for (int i = bitWidth - 1; i >= 0; i--) {
            if (!x.testBit(i)) {
                leadingZeroes++;
            } else {
                break;
            }
        }
        return BigInteger.valueOf(leadingZeroes);
    }

    public static BigInteger cttz(BigInteger x, int bitWidth) {
        int trailingZeroes = 0;
        for (int i = 0; i < bitWidth; i++) {
            if (!x.testBit(i)) {
                trailingZeroes++;
            } else {
                break;
            }
        }
        return BigInteger.valueOf(trailingZeroes);
    }

}
