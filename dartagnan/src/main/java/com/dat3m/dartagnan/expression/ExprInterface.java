package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.google.common.collect.ImmutableSet;

public interface ExprInterface {

    default ImmutableSet<Register> getRegs() {
    	return ImmutableSet.of();
    }

    Type getType();

    <T> T visit(ExpressionVisitor<T> visitor);

    //default ExprInterface simplify() { return visit(ExprSimplifier.SIMPLIFIER); }
    
}
