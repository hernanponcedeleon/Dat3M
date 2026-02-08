package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LiteralExpressionBase;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.google.common.base.Preconditions;

import java.math.BigDecimal;

/*
    FIXME:
     - This class cannot represent all floating point special values.
     - It cannot do any computations: computations on BigDecimal do not align with computations on the true
       floating-point type (as defined by IEEE 754).
 */
public final class FloatLiteral extends LiteralExpressionBase<FloatType> {

    private final BigDecimal absValue;
    private final boolean sign;
    private final boolean isNaN;
    private final boolean isInf;

    public FloatLiteral(FloatType type, BigDecimal absValue, boolean sign, boolean isNaN, boolean isInf) {
        super(type);
        Preconditions.checkArgument(!(isNaN && isInf), "Cannot create NaN and Inf literal at the same time");
        Preconditions.checkArgument(!(isNaN && sign), "Cannot create NaN literal with negative sign");
        Preconditions.checkArgument(
                (absValue != null || isNaN || isInf)  // Has value, is NaN, or is Inf
                        && !(absValue != null && (isNaN || isInf)), // If it has value, then it is neither NaN nor Inf
                "Invalid float literal"
        );

        if (absValue != null) {
            absValue = absValue.abs();
        }
        this.absValue = absValue;
        this.sign = sign;
        this.isNaN = isNaN;
        this.isInf = isInf;
    }

    public BigDecimal getAbsValue() {
        Preconditions.checkState(hasFiniteValue(),
                "Cannot call getAbsValue on non-finite value %s", this);
        return absValue;
    }

    public boolean getSign() { return sign; }
    public boolean isNaN() { return isNaN; }
    public boolean isPlusInf() { return isInf && !sign; }
    public boolean isMinusInf() { return isInf && sign; }
    public boolean hasFiniteValue() { return absValue != null; }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitFloatLiteral(this);
    }

    @Override
    public int hashCode() {
        return getType().hashCode() ^ 0xa185f6b3 + absValue.hashCode();
    }

    @Override
    public boolean equals(Object o) {
        return this == o || (o instanceof FloatLiteral val
                && getType().equals(val.getType())
                && absValue.equals(val.absValue)
                && isNaN == val.isNaN
                && isInf == val.isInf
                && sign == val.sign);
    }

    @Override
    public String toString() {
        if (isPlusInf()) {
            return "+INF";
        } else if (isMinusInf()) {
            return "-INF";
        } else if (isNaN()) {
            return "NaN";
        }
        return String.format("%s(%s%s)", getType(), sign ? "-" : "", absValue);
    }
}
