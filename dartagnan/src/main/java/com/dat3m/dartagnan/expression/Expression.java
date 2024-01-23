package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.Type;
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
    default IntLiteral reduce() {
        throw new UnsupportedOperationException("Reduce not supported for " + this);
    }
}
