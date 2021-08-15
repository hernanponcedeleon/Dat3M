package com.dat3m.dartagnan.expression;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;

public class BNonDet extends BExpr implements ExprInterface {

	private final int precision;
	
	public BNonDet(int precision) {
		this.precision = precision;
	}
	
	@Override
	public IConst reduce() {
        throw new UnsupportedOperationException("Reduce not supported for " + this);
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
		return ctx.getFormulaManager().getBooleanFormulaManager().makeVariable(Integer.toString(hashCode()));
	}

	@Override
	public Formula getLastValueExpr(SolverContext ctx) {
		throw new UnsupportedOperationException("getLastValueExpr not supported for " + this);
	}

	@Override
	public boolean getBoolValue(Event e, Model model, SolverContext ctx) {
		return model.evaluate(toBoolFormula(e, ctx)).booleanValue();
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
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
