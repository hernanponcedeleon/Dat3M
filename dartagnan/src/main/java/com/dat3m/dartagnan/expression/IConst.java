package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.event.core.Event;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

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

	@Override
    public Formula toIntFormula(Event e, SolverContext ctx) {
		return toIntFormula(ctx);
	}

	public Formula toIntFormula(SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		return getPrecision() > 0
				? fmgr.getBitvectorFormulaManager().makeBitvector(getPrecision(),getValue())
				: fmgr.getIntegerFormulaManager().makeNumber(getValue());
	}

	@Override
	public Formula getLastValueExpr(SolverContext ctx){
		return toIntFormula(ctx);
	}

	@Override
	public BigInteger getIntValue(Event e, Model model, SolverContext ctx){
		return getValue();
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
