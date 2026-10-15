package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.Register;

import java.util.Set;

public interface RegReader extends Event {
    Set<Register.Read> getRegisterReads();

    void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer);

    // TODO: Separate expression traversal from rewriting so inspection does not
    // invoke transformation code and cannot replace expressions.
    default void inspectExpressions(ExpressionInspector inspector) {
        transformExpressions(inspector);
    }
}
