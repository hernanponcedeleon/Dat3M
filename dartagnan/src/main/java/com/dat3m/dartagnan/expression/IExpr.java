package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.type.IntegerType;

import static com.google.common.base.Preconditions.checkNotNull;

public abstract class IExpr implements Reducible {

	private final IntegerType type;

	protected IExpr(IntegerType type) {
		this.type = checkNotNull(type);
	}

	public IExpr getBase() {
		throw new UnsupportedOperationException("getBase() not supported for " + this);
	}
	
	@Deprecated
	public int getPrecision() {
		return type.isMathematical() ? -1 : type.getBitWidth();
	}
	
	@Override
	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	public boolean isBV() { return getPrecision() > 0; }
	public boolean isInteger() { return getPrecision() <= 0; }

	@Override
	public final IntegerType getType() {
		return type;
	}
}
