package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LiteralExpressionBase;
import com.dat3m.dartagnan.expression.type.FloatType;

import java.math.BigDecimal;

/*
    FIXME:
     - This class cannot represent all floating point special values.
     - It cannot do any computations: computations on BigDecimal do not align with computations on the true
       floating-point type (as defined by IEEE 754).
 */
public final class FloatLiteral extends LiteralExpressionBase<FloatType> {

    private final BigDecimal value;
    private final boolean isNAN;
    private final boolean isInf;

    public FloatLiteral(FloatType type, BigDecimal value, boolean isNAN, boolean isInf) {
        super(type);
        this.value = value;
        this.isNAN = isNAN;
        this.isInf = isInf;
    }

    public BigDecimal getValue() {
        return value;
    }

    public double getValueAsDouble() {
        return value.doubleValue();
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitFloatLiteral(this);
    }

    @Override
    public int hashCode() {
        return getType().hashCode() ^ 0xa185f6b3 + value.hashCode();
    }

    @Override
    public boolean equals(Object o) {
        return this == o || (o instanceof FloatLiteral val
                && getType().equals(val.getType())
                && value.equals(val.value)
                && isNAN == val.isNAN
                && isInf == val.isInf);
    }

    @Override
    public String toString() {
        return String.format("%s(%s)", getType(), value);
    }
}
