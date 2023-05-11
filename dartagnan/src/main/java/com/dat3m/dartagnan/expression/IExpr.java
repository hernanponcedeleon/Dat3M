package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;

public abstract class IExpr implements Expression {

	public int getPrecision() {
		throw new UnsupportedOperationException("getPrecision() not supported for " + this);
	}

	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	public boolean isBV() { return getPrecision() > 0; }

	public boolean isInteger() { return getPrecision() <= 0; }

	@Override
	public Type getType() {
		int precision = getPrecision();
		TypeFactory types = TypeFactory.getInstance();
		return precision < 0 ? types.getNumberType() : types.getIntegerType(precision);
	}
}
