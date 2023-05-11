package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;

public abstract class IExpr implements Reducible {

	public IExpr getBase() {
		throw new UnsupportedOperationException("getBase() not supported for " + this);
	}
	
	@Deprecated
	public int getPrecision() {
		throw new UnsupportedOperationException("getPrecision() not supported for " + this);
	}
	
	@Override
	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	public boolean isBV() { return getPrecision() > 0; }
	public boolean isInteger() { return getPrecision() <= 0; }

	@Override
	public IntegerType getType() {
		TypeFactory types = TypeFactory.getInstance();
		int precision = getPrecision();
		return precision < 0 ? types.getIntegerType() : types.getIntegerType(precision);
	}
}
