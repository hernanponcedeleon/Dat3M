package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.expression.type.BooleanType;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

public abstract class BExpr implements ExprInterface {

    public boolean isTrue() {
        return this.equals(BConst.TRUE);
    }

    public boolean isFalse() {
        return this.equals(BConst.FALSE);
    }

    @Override
    public BooleanType getType() {
        return TypeFactory.getInstance().getBooleanType();
    }
}
