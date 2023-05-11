package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.type.IntegerType;
import com.dat3m.dartagnan.program.expression.type.NumberType;

public abstract class IExpr implements Expression {

	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	public boolean isBV() { return getType() instanceof IntegerType; }

	public boolean isInteger() { return getType() instanceof NumberType; }
}
