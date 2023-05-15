package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.expression.AbstractExpression;
import com.dat3m.dartagnan.program.expression.type.Type;

import java.math.BigInteger;

/**
 * Expressions whose results are known before an execution starts.
 */
public abstract class IConst extends AbstractExpression {

    protected IConst(Type type) {
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
}
