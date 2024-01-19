package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.type.IntegerType;

import java.math.BigInteger;

/**
 * Expressions whose results are known before an execution starts.
 */
public abstract class IntConst extends IntExpr {

    protected IntConst(IntegerType type) {
        super(type);
    }

    /**
     * @return The concrete result that all valid executions agree with.
     */
    public abstract BigInteger getValue();

    public int getValueAsInt() {
        return getValue().intValue();
    }


    @Override
    public IntConst reduce() {
        return this;
    }
}
