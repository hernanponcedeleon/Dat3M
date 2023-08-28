package com.dat3m.dartagnan.program.event.core.utils;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.Set;

public interface RegReader extends Event {
    Set<Register.Read> getRegisterReads();

    void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer);
}
