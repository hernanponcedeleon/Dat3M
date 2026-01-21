package com.dat3m.dartagnan.program.analysis.interval;

import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.google.common.base.Preconditions;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


import java.math.BigInteger;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.function.UnaryOperator;



// Class to represent closed integer intervals for registers.
// A closed interval [lb,ub] means that a register may be any value from lb to ub.
// Since registers are represented by bit vectors, the values are bounded by the minimum and maximum value.
// E.g. a register bv8 r0 has a lower bound of -128 (signed) and 255 (unsigned)
// At any time, we assume the signedness of the register based on the bounds. 
// E.g. if the lower bound of a register < 0 then we assume its signed otherwise we assume unsignedness.
// Whenever this becomes ambiguous we assume the widest possible interval. 
// Note for r0 that the most general interval itself is ambiguous [-128,255]
// We disallow such interval since they are tricky to encode in bitvector theory

public class Interval implements Cloneable {

    private final BigInteger lowerbound;
    private final BigInteger upperbound;
    private final IntegerType type;
    private SignState signState = SignState.UNKNOWN;

    static Set<Object> unsupportedOperators = new HashSet<>();
    @SuppressWarnings("unused")
    Logger logger = LogManager.getLogger(Interval.class);


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

    public enum SignState {
        UNKNOWN,
        SIGNED,
        UNSIGNED
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


    public static Interval makeSingleton(BigInteger value,IntegerType type) {
        return new Interval(value,value,type);
    }

    public Interval join(Interval interval2) {
        return new Interval(this.lowerbound.min(interval2.lowerbound),this.upperbound.max(interval2.upperbound),this.getType());    }

    public boolean isTop(IntegerType type) {
        return this.equals(Interval.getTop(type));
    }

    public Interval applyOperator(IntBinaryOp op, Interval interval, IntegerType type) {
        return switch (op) {
            case ADD, SUB, MUL, DIV, OR, AND -> applyOperatorMethod(op,interval,type);
            default -> {
                unsupportedOperators.add(op);
                yield Interval.getTop(type);
            }
        };
    }

    public boolean isSignInsensitive() {
        boolean isUnknown = signState.equals(SignState.UNKNOWN);
        return (isUnknown && allNegative()) || (isUnknown && allNonNegative() && !crossesSignBoundary());
    }

    public SignState getSignState() {
        return signState;
    }

    public void setSignUnknown() {
        signState = SignState.UNKNOWN;
    }

    public void setSignSigned() {
        signState = SignState.SIGNED;
    }

    public void setSignUnsigned() {
        signState = SignState.UNSIGNED;
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

    private Interval applyOperatorMethod(IntBinaryOp op, Interval interval,IntegerType type) {
        Interval newInterval;
        UnaryOperator<Interval> opFunc = selectOperatorMethod(op);
        if(opFunc != null && !this.isTop(type) && !interval.isTop(type)) {
            if (op == IntBinaryOp.DIV && 
        (interval.lowerbound.compareTo(BigInteger.ZERO) > 0 ||
            interval.upperbound.compareTo(BigInteger.ZERO) < 0)) {
                newInterval = opFunc.apply(interval);

            } else if(op != IntBinaryOp.DIV) {
                newInterval = opFunc.apply(interval);
            } else {
                newInterval = Interval.getTop(type);
            }
        } else {
            newInterval = Interval.getTop(type);
        }
        return newInterval;
    }


    private UnaryOperator<Interval> selectOperatorMethod(IntBinaryOp op) {
        return switch (op) {
            case ADD -> this::add;
            case SUB -> this::subtract;
            case MUL -> this::multiply;
            case DIV -> this::divide;
            case OR -> this::or;
            case AND -> this::and;
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
        BigInteger resultBoundLowerBoundsInt = resultBoundLowerBounds.setScale(0,RoundingMode.HALF_UP).toBigInteger();
        BigInteger resultBoundUpperBoundsInt = resultBoundUpperBounds.setScale(0,RoundingMode.HALF_UP).toBigInteger();
        return new Interval(resultBoundLowerBoundsInt,resultBoundUpperBoundsInt,this.getType());
    }


    private Interval divide(Interval i2) {
        MathContext mc = new MathContext(3, RoundingMode.HALF_UP);
        BigDecimal lowerboundI1 = new BigDecimal(this.lowerbound,mc);
        BigDecimal upperboundI1 = new BigDecimal(this.upperbound,mc);
        BigDecimal lowerboundI2 = new BigDecimal(i2.lowerbound,mc);
        BigDecimal upperboundI2 = new BigDecimal(i2.upperbound,mc);
        BigDecimal reciprocalLowerbound = BigDecimal.ONE.divide(lowerboundI2,mc);
        BigDecimal reciprocalUpperbound = BigDecimal.ONE.divide(upperboundI2,mc);
        return multiply(lowerboundI1,upperboundI1,reciprocalLowerbound,reciprocalUpperbound);
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

    private static class BigIntPair {
        BigInteger min,max;

        BigIntPair() {}


    }

    private Interval doOR(BigInteger lb1 ,BigInteger lb2 ,BigInteger ub1 ,BigInteger ub2 ,IntegerType type) {
        char signs = constructSignNumber(lb1, ub1, lb2, ub2);
        switch (signs) {
            case 0b1111:
            case 0b0000:
            case 0b0011:
            case 0b1100:
            return new Interval(minOR(lb1,lb2,ub1,ub2),maxOR(lb1,lb2,ub1,ub2),type);

            case 0b0001:
            return new Interval(lb1,new BigInteger("-1"),type);

            case 0b0100:
            return new Interval(lb2,new BigInteger("-1"),type);

            case 0b0101: 
            return new Interval(lb1.min(lb2),maxOR(BigInteger.ZERO,BigInteger.ZERO,ub1,ub2),type);

            case 0b0111:
            return new Interval(minOR(lb1,lb2,setAllBits(ub1.bitLength()),ub2),maxOR(BigInteger.ZERO,lb2,ub1,ub2),type);

            case 0b1101:
            return new Interval(minOR(lb1,lb2,ub1,setAllBits(ub2.bitLength())),maxOR(lb1,BigInteger.ZERO,ub1,ub2),type);
            default: 
            return Interval.getTop(type);

        }
    }



    private Interval or(Interval interval) {
        BigInteger lb1 = this.lowerbound;
        BigInteger lb2 = interval.lowerbound;
        BigInteger ub1 = this.upperbound;
        BigInteger ub2 = interval.upperbound;
        IntegerType type = this.type;
        return doOR(lb1,lb2,ub1,ub2,type);
    }


    private Interval and(Interval interval) {
        BigInteger lb1 = this.lowerbound;
        BigInteger lb2 = interval.lowerbound;
        BigInteger ub1 = this.upperbound;
        BigInteger ub2 = interval.upperbound; 
        IntegerType type = this.type; 
        Interval orInterval = doOR(ub1.not(),ub2.not(),lb1.not(),lb2.not(),type);
        BigInteger maxAnd = orInterval.getLowerbound().not();
        BigInteger minAnd = orInterval.getUpperbound().not();
        return new Interval(minAnd,maxAnd,type);
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
        return "[ " + this.lowerbound + ", " + this.upperbound + " ]" + " Sign: " + signState+"; ";
    }

    @Override
    protected Interval clone() throws CloneNotSupportedException {
        return (Interval) super.clone();

    }
}
