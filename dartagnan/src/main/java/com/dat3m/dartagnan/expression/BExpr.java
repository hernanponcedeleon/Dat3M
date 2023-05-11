package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.type.BooleanType;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

public abstract class BExpr implements Expression {

    @Override
    public BooleanType getType() {
        return TypeFactory.getInstance().getBooleanType();
    }
}
