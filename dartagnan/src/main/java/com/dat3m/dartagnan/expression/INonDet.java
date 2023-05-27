package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;

import java.math.BigInteger;
import java.util.Optional;

// TODO why is INonDet not a IConst?
public class INonDet extends IExpr {

    private final String id;
    private final boolean signed;
    private final BigInteger min;
    private final BigInteger max;

    // Should only be accessed from Program
    public INonDet(int id, IntegerType type, boolean signed, BigInteger min, BigInteger max) {
        super(type);
        this.id = Integer.toString(id);
        this.signed = signed;
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
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        IntegerType type = getType();
        if (type.isMathematical()) {
            return String.format("nondet_int(%d,%s,%s)", id, min, max);
        }
        return String.format("nondet_%c%d(%d,%s,%s)", signed ? 's' : 'u', type.getBitWidth(), id, min, max);
    }
}
