package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntUnaryOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.function.UnaryOperator;
import java.util.function.Supplier;



// Class to represent closed integer intervals for registers.
// A closed interval [lb,ub] means that a register may be any value from lb to ub.
// Since registers are represented by bit vectors, the values are bounded by the minimum and maximum value.
// E.g. a register bv8 r0 has a lower bound of -128 (signed) and 255 (unsigned)
// We do not assume anything about the signedness of a register associated with an interval.

public final class Interval {

    private final BigInteger lowerbound;
    private final BigInteger upperbound;
    private final IntegerType type;

    static Set<ExpressionKind> unsupportedOperators = new HashSet<>();


    public Interval(BigInteger lowerbound, BigInteger upperbound, IntegerType type) {
        Preconditions.checkArgument(lowerbound.compareTo(upperbound) <= 0);
        this.type = type;
        BigInteger minBound = type.getMinimumValue(true);
        BigInteger maxBoundU = type.getMaximumValue(false);
        BigInteger maxBoundS = type.getMaximumValue(true);

        // Values do not fit target type or the interval contains both signed and unsigned values
        if ((lowerbound.compareTo(minBound) < 0 || upperbound.compareTo(maxBoundU) > 0)
                || (lowerbound.compareTo(BigInteger.ZERO) < 0 && upperbound.compareTo(maxBoundS) > 0)) {
            this.lowerbound = minBound;
            this.upperbound = maxBoundU;
        } else {
            this.lowerbound = lowerbound;
            this.upperbound = upperbound;
        }
    }

    public Interval(BigInteger value, IntegerType type) {
        this(value, value, type);
    }

    public BigInteger getLowerbound() {
        return lowerbound;
    }

    public BigInteger getUpperbound() {
        return upperbound;
    }

    public static Set<ExpressionKind> getUnsupportedOperatorsFound() {
        return unsupportedOperators;
    }

    public static Interval getTop(IntegerType type) {
        return new Interval(type.getMinimumValue(true), type.getMaximumValue(false), type);
    }

    public BigInteger size() {
        return (this.upperbound.subtract(this.lowerbound)).add(BigInteger.ONE);
    }

    public Interval join(Interval other) {
        return new Interval(this.lowerbound.min(other.lowerbound), this.upperbound.max(other.upperbound), type);
    }

    public boolean isTop() {
        return this.equals(Interval.getTop(type));
    }

    public boolean isSignInsensitive() {
        return allNegative() || (allNonNegative() && !crossesSignBoundary());
    }

    public Interval applyOperator(IntBinaryOp op, Interval other) {
        UnaryOperator<Interval> opFunc = selectBinaryOperatorMethod(op);
        if (opFunc == null || this.isTop() || other.isTop()) {
            return Interval.getTop(type);
        }
        return opFunc.apply(other);
    }

    public Interval applyOperator(IntUnaryOp op) {
        Supplier<Interval> opFunc = selectUnaryOperatorMethod(op);
        if (this.isTop()) {
            return Interval.getTop(type);
        }
        return opFunc.get();
    }

    // ====================================================================================
    // Private implementation

    // Predicates

    private boolean crossesZero() {
        return lowerbound.compareTo(BigInteger.ZERO) <= 0 && upperbound.compareTo(BigInteger.ZERO) >= 0;
    }

    private boolean allNegative() {
        return upperbound.compareTo(BigInteger.ZERO) < 0;
    }

    private boolean allNonNegative() {
        return lowerbound.compareTo(BigInteger.ZERO) >= 0;
    }

    private boolean crossesSignBoundary() {
        return (lowerbound.signum() >= 0 && lowerbound.compareTo(type.getMaximumValue(true)) <= 0) && upperbound.compareTo(type.getMaximumValue(true)) > 0;
    }

    // Operators

    private UnaryOperator<Interval> selectBinaryOperatorMethod(IntBinaryOp op) {
        return switch (op) {
            case ADD -> this::add;
            case SUB -> this::subtract;
            case MUL -> this::multiply;
            case DIV -> this::sdivide;
            case UDIV -> this::udivide;
            case OR -> this::or;
            case AND -> this::and;
            case LSHIFT -> this::lshift;
            case RSHIFT -> this::rshift;
            case ARSHIFT -> this::arshift;
            case SMIN -> this::smin;
            case SMAX -> this::smax;
            case UMIN -> this::umin;
            case UMAX -> this::umax;
            default -> {
                unsupportedOperators.add(op);
                yield null;
            }
        };
    }

    private Supplier<Interval> selectUnaryOperatorMethod(IntUnaryOp op) {
        return switch (op) {
            case MINUS -> this::negate;
            case CTPOP, CTTZ -> this::getBitwidthInterval;
            case CTLZ -> this::ctlz;
            case NOT -> this::not;
        };
    }

    private Interval subtract(Interval other) {
        return new Interval(this.lowerbound.subtract(other.upperbound), this.upperbound.subtract(other.lowerbound), type);
    }

    private Interval add(Interval other) {
        return new Interval(this.lowerbound.add(other.lowerbound), this.upperbound.add(other.upperbound), type);
    }

    private Interval multiply(Interval other) {
        BigInteger ll =  lowerbound.multiply(other.lowerbound);
        BigInteger lu =  lowerbound.multiply(other.upperbound);
        BigInteger ul =  upperbound.multiply(other.lowerbound);
        BigInteger uu =  upperbound.multiply(other.upperbound);

        return new Interval(ll.min(lu).min(ul).min(uu), ll.max(lu).max(ul).max(uu), type);
    }

    private Interval sdivide(Interval other) {
        if (!(isSignInsensitive() && other.isSignInsensitive())) {
            return Interval.getTop(type);
        }
        Interval signedInterval = this.convertToSignedInterval();
        Interval signedIntervalOther = other.convertToSignedInterval();

        if (signedInterval.lowerbound.compareTo(type.getMinimumValue(true)) == 0 && signedIntervalOther.upperbound.compareTo(BigInteger.ONE.negate()) == 0) {
            return Interval.getTop(type);
        }
        return divide(signedInterval, signedIntervalOther);
    }

    private Interval udivide(Interval other) {
        if (!(isSignInsensitive() && other.isSignInsensitive())) {
            return Interval.getTop(type);
        }
        Interval unsignedInterval = this.convertToUnsignedInterval();
        Interval unsignedIntervalOther = other.convertToUnsignedInterval();
        return divide(unsignedInterval, unsignedIntervalOther);
    }

    private Interval or(Interval other) {
        return doOR(this.lowerbound,
                other.lowerbound,
                this.upperbound,
                other.upperbound);
    }

    private Interval and(Interval other) {
        Interval orInterval = this.not().or(other.not());
        return new Interval(orInterval.upperbound.not(),
                orInterval.lowerbound.not(),
                type);
    }

    private Interval min(Interval other) {
        return new Interval(lowerbound.min(other.lowerbound), upperbound.min(other.upperbound), type);
    }

    private Interval max(Interval other) {
        return new Interval(lowerbound.max(other.lowerbound), upperbound.max(other.upperbound), type);
    }

    private Interval smin(Interval other) {
        return doMinMax(other, true, true);
    }

    private Interval smax(Interval other) {
       return doMinMax(other, false, true);
    }

    private Interval umin(Interval other) {
       return doMinMax(other, true, false);
    }

    private Interval umax(Interval other) {
        return doMinMax(other, false, false);
    }

    private Interval negate() {
        return new Interval(upperbound.negate(), lowerbound.negate(), type);
    }

    private Interval ctlz() {
        if (crossesZero()) {
            return getBitwidthInterval();
        }
        return new Interval(IntegerHelper.ctlz(upperbound, type.getBitWidth()), IntegerHelper.ctlz(lowerbound, type.getBitWidth()), type);
    }

    private Interval not() {
        return new Interval(upperbound.not(), lowerbound.not(), type);
    }

    private Interval lshift(Interval shiftInterval) {
        BigInteger shiftBy = shiftInterval.lowerbound;
        return new Interval(
                IntegerHelper.lshift(lowerbound, shiftBy, type.getBitWidth()),
                IntegerHelper.lshift(upperbound, shiftBy, type.getBitWidth()),
                type);
    }

    private Interval rshift(Interval shiftInterval) {
        BigInteger shiftBy = shiftInterval.lowerbound;

        if (crossesZero()) {
            return Interval.getTop(type);
        }
        return new Interval(
                IntegerHelper.rshift(lowerbound, shiftBy, type.getBitWidth()),
                IntegerHelper.rshift(upperbound, shiftBy, type.getBitWidth()),
                type
        );
    }

    private Interval arshift(Interval shiftInterval) {
        BigInteger shiftBy = shiftInterval.lowerbound;
        return new Interval(
                IntegerHelper.arshift(lowerbound, shiftBy, type.getBitWidth()),
                IntegerHelper.arshift(upperbound, shiftBy, type.getBitWidth()),
                type
        );
    }

    // Helpers

    private Interval getBitwidthInterval() {
        return new Interval(BigInteger.ZERO, BigInteger.valueOf(type.getBitWidth()), type);
    }

    private Interval divide(Interval numeratorInterval, Interval denominatorInterval) {
        if (denominatorInterval.crossesZero()) {
            return Interval.getTop(type);
        }
        BigInteger llDiv = numeratorInterval.lowerbound.divide(denominatorInterval.lowerbound);
        BigInteger luDiv = numeratorInterval.lowerbound.divide(denominatorInterval.upperbound);
        BigInteger ulDiv = numeratorInterval.upperbound.divide(denominatorInterval.lowerbound);
        BigInteger uuDiv = numeratorInterval.upperbound.divide(denominatorInterval.upperbound);

        return new Interval(llDiv.min(luDiv).min(ulDiv).min(uuDiv),
                llDiv.max(luDiv).max(ulDiv).max(uuDiv),
                type);
    }

    private int getBiggerBitLength(BigInteger x, BigInteger y) {
        int lengthX = (x.signum() > 0) ? x.bitLength() : x.bitLength() + 1;
        int lengthY = (y.signum() > 0) ? y.bitLength() : y.bitLength() + 1;
        return Math.max(lengthX, lengthY);
    }

    // Algorithms and relations based on:
    // Hacker's Delight second edition
    // Author Henry S. Warren, Jr.
    // Chapter 4-3
    private BigInteger minOR(BigInteger lb1, BigInteger lb2, BigInteger ub1, BigInteger ub2) {
        BigInteger m = BigInteger.TWO.pow((getBiggerBitLength(lb1, lb2)));
        BigInteger temp;

        while (!m.equals(BigInteger.ZERO)) {
            if (!(lb1.not().and(lb2).and(m).equals(BigInteger.ZERO))) {
                temp = (lb1.or(m).and(m.negate()));
                if (temp.compareTo(ub1) <= 0) {
                    lb1 = temp;
                    break;
                }
            } else if (!(lb1.and(lb2.not()).and(m).equals(BigInteger.ZERO))) {
                temp = (lb2.or(m).and(m.negate()));
                if (temp.compareTo(ub2) <= 0) {
                    lb2 = temp;
                    break;
                }
            }
            m = m.shiftRight(1);
        }
        return lb1.or(lb2);
    }

    private BigInteger maxOR(BigInteger lb1, BigInteger lb2, BigInteger ub1, BigInteger ub2) {
        BigInteger m = BigInteger.TWO.pow(getBiggerBitLength(ub1, ub2));
        BigInteger temp;

        while (!m.equals(BigInteger.ZERO)) {
            if (!ub1.and(ub2).and(m).equals(BigInteger.ZERO)) {
                temp = (ub1.subtract(m)).or(m.subtract(BigInteger.ONE));
                if (temp.compareTo(lb1) >= 0) {
                    ub1 = temp;
                    break;
                }
                temp = (ub2.subtract(m)).or(m.subtract(BigInteger.ONE));
                if (temp.compareTo(lb2) >= 0) {
                    ub2 = temp;
                    break;
                }
            }
            m = m.shiftRight(1);
        }
        return ub1.or(ub2);
    }

    private char constructSignNumber(BigInteger lb1, BigInteger ub1, BigInteger lb2, BigInteger ub2) {
        char signs = 0b0000;
        if (lb1.signum() > 0) {
            signs |= 0b1000;
        }
        if (ub1.signum() > 0) {
            signs |= 0b0100;
        }
        if (lb2.signum() > 0) {
            signs |= 0b0010;
        }
        if (ub2.signum() > 0) {
            signs |= 0b0001;
        }
        return signs;
    }

    private BigInteger setAllBits(int length) {
        char[] ones = new char[length];
        Arrays.fill(ones, '1');
        return new BigInteger(new String(ones), 2);
    }

    private Interval doOR(BigInteger lb1, BigInteger lb2, BigInteger ub1, BigInteger ub2) {
        char signs = constructSignNumber(lb1, ub1, lb2, ub2);
        return switch (signs) {
            case 0b1111, 0b0000, 0b0011, 0b1100 ->
                    new Interval(minOR(lb1, lb2, ub1, ub2), maxOR(lb1, lb2, ub1, ub2), type);
            case 0b0001 -> new Interval(lb1, new BigInteger("-1"), type);
            case 0b0100 -> new Interval(lb2, new BigInteger("-1"), type);
            case 0b0101 -> new Interval(lb1.min(lb2), maxOR(BigInteger.ZERO, BigInteger.ZERO, ub1, ub2), type);
            case 0b0111 ->
                    new Interval(minOR(lb1, lb2, setAllBits(ub1.bitLength()), ub2), maxOR(BigInteger.ZERO, lb2, ub1, ub2), type);
            case 0b1101 ->
                    new Interval(minOR(lb1, lb2, ub1, setAllBits(ub2.bitLength())), maxOR(lb1, BigInteger.ZERO, ub1, ub2), type);
            default -> Interval.getTop(type);
        };
    }

    private Interval convertToSignedInterval() {
        int width = this.type.getBitWidth();
        return new Interval(
                IntegerHelper.normalizeSigned(this.lowerbound, width),
                IntegerHelper.normalizeSigned(this.upperbound, width),
                type);
    }

    private Interval convertToUnsignedInterval() {
        int width = this.type.getBitWidth();
        return new Interval(
                IntegerHelper.normalizeUnsigned(this.lowerbound, width),
                IntegerHelper.normalizeUnsigned(this.upperbound, width),
                type);
    }

    private Interval doMinMax(Interval other, boolean isMin, boolean signed) {
        if (!(isSignInsensitive() && other.isSignInsensitive())) {
            return Interval.getTop(type);
        }

        Interval convertedInterval = signed ? convertToSignedInterval() : convertToUnsignedInterval();
        Interval convertedIntervalOther =  signed ? other.convertToSignedInterval() : other.convertToUnsignedInterval();

        return isMin ? convertedInterval.min(convertedIntervalOther) : convertedInterval.max(convertedIntervalOther);
    }

    @Override
    public boolean equals(Object other) {
        if (other == null) {
            return false;
        }
        if (other.getClass() != this.getClass()) {
            return false;
        }
        final Interval otherInterval = (Interval) other;
        return (otherInterval.lowerbound.equals(this.lowerbound) && otherInterval.upperbound.equals(this.upperbound));
    }

    @Override
    public String toString() {
        return "[ " + this.lowerbound + ", " + this.upperbound + " ];";
    }
}
