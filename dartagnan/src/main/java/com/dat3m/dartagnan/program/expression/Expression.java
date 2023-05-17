package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.type.BooleanType;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;

public interface Expression {

    Type getType();

    <T> T visit(ExpressionVisitor<T> visitor);

    default boolean isTrue() {
        return this instanceof Literal && isBoolean() && !((Literal) this).getValue().equals(BigInteger.ZERO);
    }

    default boolean isFalse() {
        return this instanceof Literal && isBoolean() && ((Literal) this).getValue().equals(BigInteger.ZERO);
    }

    default ImmutableSet<Register> getRegs() {
        return ImmutableSet.of();
    }

    default boolean isBoolean() {
        return getType() instanceof BooleanType;
    }
}
