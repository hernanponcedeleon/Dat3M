package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.type.IntegerType;

import java.math.BigInteger;

/**
 * Expressions whose results are known before an execution starts.
 */
public abstract class IConst extends IExpr {

	protected IConst(IntegerType type) {
		super(type);
	}

    /**
     * @return
     * The concrete result that all valid executions agree with.
     */
    public abstract BigInteger getValue();

	public int getValueAsInt() {
		return getValue().intValue();
	}


	@Override
	public IConst reduce() {
		return this;
	}
	
	@Override
	public IExpr getBase() {
		return this;
	}
}
