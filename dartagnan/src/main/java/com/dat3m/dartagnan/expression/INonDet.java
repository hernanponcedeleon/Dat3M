package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;

import java.math.BigInteger;
import java.util.Optional;

// TODO why is INonDet not a IConst?
public class INonDet extends IExpr {

    private final int id;
    private final boolean signed;
    private BigInteger min;
    private BigInteger max;
    private String sourceName;

    // Should only be accessed from Program
    public INonDet(int id, IntegerType type, boolean signed) {
        super(type);
        this.id = id;
        this.signed = signed;
    }

    public String getName() {
        return Integer.toString(id);
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

    public void setMin(BigInteger bound) {
        min = bound;
    }

    public void setMax(BigInteger bound) {
        max = bound;
    }

    public void setSourceName(String name) {
        sourceName = name;
    }

    @Override
    public IConst reduce() {
        if (min.equals(max)) {
            return new IValue(min, getType());
        }
        return super.reduce();
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        if (sourceName != null) {
            return sourceName;
        }
        IntegerType type = getType();
        if (type.isMathematical()) {
            return String.format("nondet_int(%d,%s,%s)", id, min, max);
        }
        return String.format("nondet_%c%d(%d,%s,%s)", signed ? 's' : 'u', type.getBitWidth(), id, min, max);
    }
}
