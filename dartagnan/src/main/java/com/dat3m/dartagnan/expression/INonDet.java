package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;

import java.math.BigInteger;
import java.util.Optional;

// TODO why is INonDet not a IConst?
public class INonDet extends IExpr {

    private final String id;
    private final int precision;
    private final boolean signed;
    private final BigInteger min;
    private final BigInteger max;

    // Should only be accessed from Program
    public INonDet(int id, int precision, boolean signed, BigInteger min, BigInteger max) {
        this.id = Integer.toString(id);
        this.signed = signed;
        this.precision = precision;
        this.min = min;
        this.max = max;
    }

    public String getName() {
        return id;
    }

    public boolean isSigned() {
        return signed;
    }

    public Optional<BigInteger> getMin() {
        return Optional.ofNullable(min);
    }

    public Optional<BigInteger> getMax() {
        return Optional.ofNullable(max);
    }

    @Override
    public int getPrecision() {
        return precision;
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return String.format("nondet_%c%d(%s,%s)", signed ? 'i' : 'u', precision, min, max);
    }
}
