package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.expression.type.IntegerType;
import com.dat3m.dartagnan.program.expression.type.Type;

import java.math.BigInteger;
import java.util.Optional;

// TODO why is INonDet not a IConst?
public class INonDet extends IExpr {

    private final String id;
    private final Type type;
    private final boolean signed;
    private final BigInteger min;
    private final BigInteger max;

    // Should only be accessed from Program
    public INonDet(int id, Type type, boolean signed, BigInteger min, BigInteger max) {
        if (!type.isLeafType()) {
            throw new UnsupportedOperationException("Nondeterministic expression of type " + type);
        }
        this.id = Integer.toString(id);
        this.signed = signed;
        this.type = type;
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
    public Type getType() {
        return type;
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        if (type instanceof IntegerType) {
            return String.format("nondet_%c%d(%s,%s)", signed ? 'i' : 'u', ((IntegerType) type).getBitWidth(), min, max);
        }
        return String.format("nondet_%s(%s,%s)", type, min, max);
    }
}
