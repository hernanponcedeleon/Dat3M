package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntUnaryOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;
import com.google.common.base.Preconditions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigInteger;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.function.UnaryOperator;
import java.util.function.Supplier;



//Class to represent closed integer intervals for registers.
// A closed interval [lb,ub] means that a register may be any value from lb to ub.
// Since registers are represented by bit vectors, the values are bounded by the minimum and maximum value.
// E.g. a register bv8 r0 has a lower bound of -128 (signed) and 255 (unsigned)
// We do not assume anything about the signedness of a register associated with an interval.

final public class Interval {

    private final BigInteger lowerbound;
    private final BigInteger upperbound;
    private final IntegerType type;

    static Set<Object> unsupportedOperators = new HashSet<>();
    @SuppressWarnings("unused")
    Logger logger = LoggerFactory.getLogger(Interval.class);


    public Interval(BigInteger lowerbound, BigInteger upperbound,IntegerType type) {
        Preconditions.checkArgument(lowerbound.compareTo(upperbound) <= 0);
        this.type = type;
        BigInteger minBound = type.getMinimumValue(true);
        BigInteger maxBoundU = type.getMaximumValue(false);
        BigInteger maxBoundS = type.getMaximumValue(true);
        // Values do not fit target type or the interval contains both signed and unsigned values
        if ((lowerbound.compareTo(minBound) < 0 || upperbound.compareTo(maxBoundU) > 0) || 
    (lowerbound.compareTo(BigInteger.ZERO) < 0 && upperbound.compareTo(maxBoundS) > 0)) {
            this.lowerbound = minBound;
            this.upperbound = maxBoundU;
        } else {
            this.lowerbound = lowerbound;
            this.upperbound = upperbound;
        }

    }

    public Interval(BigInteger value, IntegerType type) {
        this(value,value,type);
    }

    public BigInteger getLowerbound() {
        return lowerbound;
    }

    public BigInteger getUpperbound() {
        return upperbound;
    }

    public IntegerType getType() {
        return type;
    }

    public static Set<Object> getUnsupportedOperatorsFound() {
        return unsupportedOperators;
    }

    public static Interval getTop(IntegerType type) {
        return new Interval(type.getMinimumValue(true),type.getMaximumValue(false),type);
    }

    public BigInteger size() {
        return (this.upperbound.subtract(this.lowerbound)).add(BigInteger.ONE);
    }


    public Interval join(Interval interval2) {
        return new Interval(this.lowerbound.min(interval2.lowerbound),this.upperbound.max(interval2.upperbound),this.getType());    }

    public boolean isTop() {
        return this.equals(Interval.getTop(type));
    }


    public boolean isSignInsensitive() {
        return allNegative() || (allNonNegative() && !crossesSignBoundary());
    }


    public Interval applyOperator(ExpressionKind op, Interval... intervals) {
        Supplier<Interval> opFunc = null;
        if(op instanceof IntUnaryOp unop && intervals.length == 0) {
            opFunc = selectUnaryOperatorMethod(unop);
        }
        else if(op instanceof IntBinaryOp binop && intervals.length == 1 && !intervals[0].isTop()) {
            opFunc = selectCurriedBinaryOperatorMethod(binop,intervals[0]);
        } else if (intervals.length > 2) {
            throw new IllegalArgumentException("More than 2 intervals specified");
        }

        if(opFunc != null && !this.isTop()) {
            return opFunc.get();
        } else return Interval.getTop(type);
    }


    private boolean doesNotCrossZero() {
        return lowerbound.compareTo(BigInteger.ZERO) > 0 || upperbound.compareTo(BigInteger.ZERO) < 0;
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

    private Supplier<Interval> selectCurriedBinaryOperatorMethod(IntBinaryOp op, Interval interval) {
        UnaryOperator<Interval> opFunc = switch (op) {
            case ADD -> this::add;
            case SUB -> this::subtract;
            case MUL -> this::multiply;
            case DIV -> this::sdivide;
            case UDIV -> this::udivide;
            case OR -> this::or;
            case AND -> this::and;
            default -> {
                unsupportedOperators.add(op);
                yield null;
            }
        };
        if (opFunc != null) {
            return () -> opFunc.apply(interval);
        } else return null;
    }

    private Supplier<Interval> selectUnaryOperatorMethod(IntUnaryOp op) {
        return switch (op) {
            case MINUS -> this::negate;
            default -> {
                unsupportedOperators.add(op);
                yield null;
            }
        };
    }

    private Interval subtract(Interval i2) {
        BigInteger resultBoundLowerBounds = this.lowerbound.subtract(i2.upperbound);
        BigInteger resultBoundUpperBounds = this.upperbound.subtract(i2.lowerbound);
        return new Interval(resultBoundLowerBounds,resultBoundUpperBounds,this.getType());
    }

    private Interval add(Interval i2) {
        BigInteger resultBoundLowerBounds = this.lowerbound.add(i2.lowerbound);
        BigInteger resultBoundUpperBounds = this.upperbound.add(i2.upperbound);
        return new Interval(resultBoundLowerBounds,resultBoundUpperBounds,this.getType());
    }

    private Interval multiply(Interval i2) {
        BigDecimal lb1 = new BigDecimal(this.lowerbound);
        BigDecimal ub1 = new BigDecimal(this.upperbound);
        BigDecimal lb2 = new BigDecimal(i2.lowerbound);
        BigDecimal ub2 = new BigDecimal(i2.upperbound);
        return multiply(lb1,ub1,lb2,ub2);
    }	



    private Interval multiply(BigDecimal lb1, BigDecimal ub1 ,BigDecimal lb2,BigDecimal ub2) {
        BigDecimal mul1 =  lb1.multiply(lb2);
        BigDecimal mul2 =  lb1.multiply(ub2);
        BigDecimal mul3 =  ub1.multiply(lb2);
        BigDecimal mul4 =  ub1.multiply(ub2);
        BigDecimal resultBoundLowerBounds = mul1.min(mul2).min(mul3).min(mul4);
        BigDecimal resultBoundUpperBounds = mul1.max(mul2).max(mul3).max(mul4);
        BigInteger resultBoundLowerBoundsInt = resultBoundLowerBounds.setScale(0,RoundingMode.FLOOR).toBigInteger();
        BigInteger resultBoundUpperBoundsInt = resultBoundUpperBounds.setScale(0,RoundingMode.CEILING).toBigInteger();
        return new Interval(resultBoundLowerBoundsInt,resultBoundUpperBoundsInt,this.getType());
    }


    private Interval sdivide(Interval i2) {
        if(this.isSignInsensitive() && i2.isSignInsensitive()) {
            Interval signedInterval1 = this.convertToSignedInterval();
            Interval signedInterval2 = i2.convertToSignedInterval();
                // Asymmetric edge case
            if (signedInterval1.lowerbound.compareTo(type.getMinimumValue(true)) == 0 && signedInterval2.upperbound.compareTo(BigInteger.ONE.negate()) == 0 ) {
                return Interval.getTop(type);
            } else {
                return divide(signedInterval1, signedInterval2);
            }
        } else {
            return Interval.getTop(type);
        }
    }


    private Interval udivide(Interval i2) {
        if(this.isSignInsensitive() && i2.isSignInsensitive()) {
            Interval unsignedInterval1 = this.convertToUnsignedInterval();
            Interval unsignedInterval2 = i2.convertToUnsignedInterval();
            return divide(unsignedInterval1, unsignedInterval2);
        } else {
            return Interval.getTop(type);
        }
    }

    private Interval divide(Interval numeratorInterval, Interval denominatorInterval) {

        if(denominatorInterval.doesNotCrossZero()) {
            BigDecimal lowerboundI1 = new BigDecimal(numeratorInterval.lowerbound);
            BigDecimal upperboundI1 = new BigDecimal(numeratorInterval.upperbound);
            BigDecimal lowerboundI2 = new BigDecimal(denominatorInterval.lowerbound);
            BigDecimal upperboundI2 = new BigDecimal(denominatorInterval.upperbound);
            // TODO: Scale 3 is a random magic constant. I do not have a better solution yet.
            BigDecimal reciprocalLowerbound = BigDecimal.ONE.divide(lowerboundI2, 3, RoundingMode.FLOOR);
            BigDecimal reciprocalUpperbound = BigDecimal.ONE.divide(upperboundI2, 3, RoundingMode.CEILING);
            return multiply(lowerboundI1, upperboundI1, reciprocalLowerbound, reciprocalUpperbound);
        } else {
            return Interval.getTop(type);
        }
    }



    private BigInteger getBiggerBitLength(BigInteger x, BigInteger y) {
        int lengthX = (x.signum() > 0) ? x.bitLength() : x.bitLength() + 1;
        int lengthY = (y.signum() > 0) ? y.bitLength() : y.bitLength() + 1;

        return (lengthX >= lengthY) ? x : y;
    }


    // Algorithms and relations based on:
    // Hacker's Delight second edition
    // Author Henry S. Warren, Jr.
    // Chapter 4-3
    private BigInteger minOR(BigInteger lb1,BigInteger lb2,BigInteger ub1,BigInteger ub2) {
        BigInteger largestBitLength = getBiggerBitLength(lb1,lb2);

        BigInteger m = BigInteger.TWO.pow(largestBitLength.bitLength());
        BigInteger temp;
        while (!m.equals(BigInteger.ZERO)) {
            if(!(lb1.not().and(lb2).and(m).equals(BigInteger.ZERO))) {
                temp = (lb1.or(m).and(m.negate()));
                if(temp.compareTo(ub1) <= 0) { lb1 = temp;break; }
            } else if (!(lb1.and(lb2.not()).and(m).equals(BigInteger.ZERO))) {
                temp = (lb2.or(m).and(m.negate()));
                if(temp.compareTo(ub2) <= 0) { lb2 = temp;break; }
            }
            m = m.shiftRight(1);
        }
        return lb1.or(lb2);

    }


    private BigInteger maxOR(BigInteger lb1,BigInteger lb2,BigInteger ub1,BigInteger ub2) {
        BigInteger largestBitLength = getBiggerBitLength(ub1,ub2);
        BigInteger m = BigInteger.TWO.pow(largestBitLength.bitLength());
        BigInteger temp;
        while (!m.equals(BigInteger.ZERO)) {
            if(!ub1.and(ub2).and(m).equals(BigInteger.ZERO)) {
                temp = (ub1.subtract(m)).or(m.subtract(BigInteger.ONE));
                if (temp.compareTo(lb1) >= 0) { ub1 = temp;break; }
                temp = (ub2.subtract(m)).or(m.subtract(BigInteger.ONE));
                if (temp.compareTo(lb2) >= 0) { ub2 = temp;break; }
            }
            m = m.shiftRight(1);
        }
        return ub1.or(ub2);
    }

    private char constructSignNumber(BigInteger lb1, BigInteger ub1, BigInteger lb2, BigInteger ub2) {
        char signs = 0b0000;
        if(lb1.signum() > 0) signs |= 0b1000;
        if(ub1.signum() > 0) signs |= 0b0100;
        if(lb2.signum() > 0) signs |= 0b0010;
        if(ub2.signum() > 0) signs |= 0b0001;

        return signs;
    }

    private BigInteger setAllBits(int length) {
        char[] ones = new char[length];
        Arrays.fill(ones,'1');
        return new BigInteger(new String(ones));
    }

    private Interval doOR(BigInteger lb1 ,BigInteger lb2 ,BigInteger ub1 ,BigInteger ub2) {
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



    private Interval or(Interval interval) {
        return doOR(this.lowerbound,
                interval.lowerbound,
                this.upperbound,
                interval.upperbound);
    }


    private Interval and(Interval interval) {
        Interval orInterval = doOR(
                this.upperbound.not(),
                interval.upperbound.not(),
                this.lowerbound.not(),
                interval.lowerbound.not());
        BigInteger maxAnd = orInterval.getLowerbound().not();
        BigInteger minAnd = orInterval.getUpperbound().not();
        return new Interval(minAnd,maxAnd,type);
    }

    private Interval negate() {
        if(upperbound.compareTo(type.getMinimumValue(true).negate()) > 0) {
            return Interval.getTop(type);
        } else {
            return new Interval(upperbound.negate(),lowerbound.negate(),type);
        }
    }


    private Interval convertToSignedInterval() {
        int width = this.type.getBitWidth();
        return new Interval(
                IntegerHelper.normalizeSigned(this.lowerbound,width),
                IntegerHelper.normalizeSigned(this.upperbound,width),
                type);
    }

    private Interval convertToUnsignedInterval() {
        int width = this.type.getBitWidth();
        return new Interval(
                IntegerHelper.normalizeUnsigned(this.lowerbound,width),
                IntegerHelper.normalizeUnsigned(this.upperbound,width),
                type);
    }




    @Override 
    public boolean equals(Object other) {
        if(other == null) {
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
