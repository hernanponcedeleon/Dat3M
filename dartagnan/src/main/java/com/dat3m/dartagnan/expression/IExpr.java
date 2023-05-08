package com.dat3m.dartagnan.expression;

public abstract class IExpr implements ExprInterface {

	public IExpr getBase() {
		throw new UnsupportedOperationException("getBase() not supported for " + this);
	}
	
	public int getPrecision() {
		throw new UnsupportedOperationException("getPrecision() not supported for " + this);
	}
	
	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	public boolean isBV() { return getPrecision() > 0; }
	public boolean isInteger() { return getPrecision() <= 0; }
}
