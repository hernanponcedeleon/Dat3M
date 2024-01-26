package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.type.IntegerType;

import java.math.BigInteger;
import java.util.Optional;

// TODO why is NonDetInt not a IntConst?
public class NonDetInt extends LeafExpressionBase<IntegerType> {

    private final int id;
    private final boolean signed;
    private BigInteger min;
    private BigInteger max;
    private String sourceName;

    // Should only be accessed from Program
    public NonDetInt(int id, IntegerType type, boolean signed) {
        super(type);
        this.id = id;
        this.signed = signed;
    }

    public String getName() {
        return "nondet_int#" + id;
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
    public ExpressionKind getKind() { return ExpressionKind.Other.NONDET; }

    @Override
    public IntLiteral reduce() {
        if (min.equals(max)) {
            return new IntLiteral(getType(), min);
        }
        return super.reduce();
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitNonDetIntExpression(this);
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
