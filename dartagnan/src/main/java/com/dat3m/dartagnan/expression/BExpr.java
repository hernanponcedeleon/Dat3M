package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.expression.AbstractExpression;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

public abstract class BExpr extends AbstractExpression {

    protected BExpr() {
        super(TypeFactory.getInstance().getBooleanType());
    }
}
