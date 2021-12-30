package com.dat3m.dartagnan.expression;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.program.event.Event;

public abstract class IExpr implements ExprInterface, Reducible {

    @Override
	public BooleanFormula toBoolFormula(Event e, SolverContext ctx) {
		FormulaManager fmgr = ctx.getFormulaManager();
		return toIntFormula(e, ctx) instanceof BitvectorFormula ? 
				fmgr.getBitvectorFormulaManager().greaterThan((BitvectorFormula)toIntFormula(e, ctx), fmgr.getBitvectorFormulaManager().makeBitvector(getPrecision(), BigInteger.ZERO), false) :
				fmgr.getIntegerFormulaManager().greaterThan((IntegerFormula)toIntFormula(e, ctx), fmgr.getIntegerFormulaManager().makeNumber(BigInteger.ZERO));
	}

    @Override
    public boolean getBoolValue(Event e, Model model, SolverContext ctx){
        return getIntValue(e, model, ctx).signum() == 1;
    }

	public IExpr getBase() {
		throw new UnsupportedOperationException("getBase() not supported for " + this);
	}
	
	public int getPrecision() {
		throw new UnsupportedOperationException("getPrecision() not supported for " + this);
	}
	
	@Override
	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	public IExpr simplify() {
		return this;
	}
}
