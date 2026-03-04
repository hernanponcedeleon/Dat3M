package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LiteralExpressionBase;
import com.dat3m.dartagnan.expression.type.FloatType;
import com.google.common.base.Preconditions;

import java.math.BigDecimal;

/*
    NOTE: This class cannot represent all floating point special values, e.g., the various versions of NaN.
          This aligns with the SMT floating point theory, which also only has a single unique NaN value.
 */
public final class FloatLiteral extends LiteralExpressionBase<FloatType> {

    private final BigDecimal absValue;
    private final boolean isNeg;
    private final boolean isNaN;
    private final boolean isInf;

    public FloatLiteral(FloatType type, BigDecimal absValue, boolean isNegative, boolean isNaN, boolean isInf) {
        super(type);
        Preconditions.checkArgument(!(isNaN && isInf), "Cannot create NaN and Inf literal at the same time");
        Preconditions.checkArgument(!(isNaN && isNegative), "Cannot create NaN literal with negative sign");
        Preconditions.checkArgument(
                (absValue != null || isNaN || isInf)  // Has value, is NaN, or is Inf
                        && !(absValue != null && (isNaN || isInf)), // If it has value, then it is neither NaN nor Inf
                "Invalid float literal"
        );

        if (absValue != null) {
            absValue = absValue.abs();
        }
        this.absValue = absValue;
        this.isNeg = isNegative;
        this.isNaN = isNaN;
        this.isInf = isInf;
    }

    public BigDecimal getAbsValue() {
        Preconditions.checkState(hasFiniteValue(),
                "Cannot call getAbsValue on non-finite value %s", this);
        return absValue;
    }

    public boolean isNegative() { return isNeg; }
    public boolean isNaN() { return isNaN; }
    public boolean isPlusInf() { return isInf && !isNeg; }
    public boolean isMinusInf() { return isInf && isNeg; }
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
                && isNeg == val.isNeg);
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
        return String.format("%s(%s%s)", getType(), isNeg ? "-" : "", absValue);
    }
}
