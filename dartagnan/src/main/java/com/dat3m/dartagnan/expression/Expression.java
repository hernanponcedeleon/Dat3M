package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

public interface Expression {

    Type getType();

    default ImmutableSet<Register> getRegs() {
        return ImmutableSet.of();
    }

    // TODO: Rename to "accept"
    <T> T visit(ExpressionVisitor<T> visitor);

    default IConst reduce() {
        throw new UnsupportedOperationException("Reduce not supported for " + this);
    }
}
