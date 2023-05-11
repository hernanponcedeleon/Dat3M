package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

public interface ExprInterface {

    default Type getType() {
        return TypeFactory.getInstance().getBooleanType();
    }

    default ImmutableSet<Register> getRegs() {
        return ImmutableSet.of();
    }

    <T> T visit(ExpressionVisitor<T> visitor);

    //default ExprInterface simplify() { return visit(ExprSimplifier.SIMPLIFIER); }
}
