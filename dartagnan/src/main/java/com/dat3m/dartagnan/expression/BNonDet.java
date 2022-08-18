package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.base.Verify;
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;

import static org.sosy_lab.java_smt.api.FormulaType.BooleanType;

public class BNonDet extends BExpr {

	private final int precision;
	
	public BNonDet(int precision) {
		this.precision = precision;
	}
	
    @Override
    public Formula toIntFormula(Event e, SolverContext ctx) {
    	FormulaManager fmgr = ctx.getFormulaManager();
    	Formula e1, e2;
    	if( precision > 0) {
    		BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
			e1 = bvmgr.makeBitvector(precision, BigInteger.ONE);
    		e2 = bvmgr.makeBitvector(precision, BigInteger.ZERO);
    	} else {
    		IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
			e1 = imgr.makeNumber(BigInteger.ONE);
    		e2 = imgr.makeNumber(BigInteger.ZERO);
    	}
        return fmgr.getBooleanFormulaManager().ifThenElse(toBoolFormula(e, ctx), e1, e2);
    }

	@Override
	public BooleanFormula toBoolFormula(Event e, SolverContext ctx) {
		return ctx.getFormulaManager().makeVariable(BooleanType, Integer.toString(hashCode()));
	}

	@Override
	public boolean getBoolValue(Event e, Model model, SolverContext ctx) {
		Boolean value = model.evaluate(toBoolFormula(e, ctx));
		Verify.verify(value != null, "No value in the model for " + this);
		return value;
	}

	@Override
	public String toString() {
		return "nondet_bool()";
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}
}
