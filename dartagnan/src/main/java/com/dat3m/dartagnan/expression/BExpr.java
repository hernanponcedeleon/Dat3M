package com.dat3m.dartagnan.expression;

public abstract class BExpr implements ExprInterface {

    public boolean isTrue() {
		return this.equals(BConst.TRUE);
	}

    public boolean isFalse() {
    	return this.equals(BConst.FALSE);
    }
}
