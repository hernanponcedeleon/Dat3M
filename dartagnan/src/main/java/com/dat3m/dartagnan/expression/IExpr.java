package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.type.IntegerType;

import static com.google.common.base.Preconditions.checkNotNull;

public abstract class IExpr implements Expression {

	private final IntegerType type;

	protected IExpr(IntegerType type) {
		this.type = checkNotNull(type);
	}

	public IExpr getBase() {
		throw new UnsupportedOperationException("getBase() not supported for " + this);
	}

	public boolean isBV() {
		return !getType().isMathematical();
	}

	public boolean isInteger() {
		return getType().isMathematical();
	}

	@Override
	public final IntegerType getType() {
		return type;
	}
}
