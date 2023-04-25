package com.dat3m.dartagnan.expression;

import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;

import java.math.BigInteger;

/**
 * Expressions whose results are known before an execution starts.
 */
public abstract class IConst extends IExpr implements LastValueInterface {

    /**
     * @return
     * The concrete result that all valid executions agree with.
     */
    public abstract BigInteger getValue();

    public Formula toIntFormula(FormulaManager fmgr) {
		return getPrecision() > 0
				? fmgr.getBitvectorFormulaManager().makeBitvector(getPrecision(),getValue())
				: fmgr.getIntegerFormulaManager().makeNumber(getValue());
	}

	@Override
	public Formula getLastValueExpr(FormulaManager m) {
		return toIntFormula(m);
	}

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
