package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.event.core.Event;
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;

public abstract class BExpr implements ExprInterface {

    @Override
    public Formula toIntFormula(Event e, SolverContext ctx) {
    	FormulaManager fmgr = ctx.getFormulaManager();
		IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
		return fmgr.getBooleanFormulaManager().ifThenElse(toBoolFormula(e, ctx), 
				imgr.makeNumber(BigInteger.ONE), 
				imgr.makeNumber(BigInteger.ZERO));
    }

    @Override
    public BigInteger getIntValue(Event e, Model model, SolverContext ctx){
        return getBoolValue(e, model, ctx) ? BigInteger.ONE : BigInteger.ZERO;
    }
    
	public boolean isTrue() {
		return this.equals(BConst.TRUE);
	}

    public boolean isFalse() {
    	return this.equals(BConst.FALSE);
    }
}
