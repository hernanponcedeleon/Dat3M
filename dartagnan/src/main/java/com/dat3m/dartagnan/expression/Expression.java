package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

import java.util.List;

public interface Expression {

    Type getType();
    List<Expression> getOperands();
    ExpressionKind getKind();
    <T> T accept(ExpressionVisitor<T> visitor);

    default ImmutableSet<Register> getRegs() {
        return ImmutableSet.of();
    }
}
