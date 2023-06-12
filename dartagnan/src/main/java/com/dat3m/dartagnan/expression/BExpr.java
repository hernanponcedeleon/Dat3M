package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

public abstract class BExpr implements Expression {

    @Override
    public BooleanType getType() {
        return TypeFactory.getInstance().getBooleanType();
    }

    public boolean isTrue() {
		return this.equals(BConst.TRUE);
	}

    public boolean isFalse() {
    	return this.equals(BConst.FALSE);
    }
}
