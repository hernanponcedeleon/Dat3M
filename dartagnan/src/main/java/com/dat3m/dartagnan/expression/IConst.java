package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.expression.Expression;

import java.math.BigInteger;

/**
 * Expressions whose results are known before an execution starts.
 */
public abstract class IConst implements Expression {

    /**
     * @return
     * The concrete result that all valid executions agree with.
     */
    public abstract BigInteger getValue();

	public int getValueAsInt() {
		return getValue().intValue();
	}
}
