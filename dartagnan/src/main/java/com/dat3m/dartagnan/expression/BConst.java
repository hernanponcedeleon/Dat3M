package com.dat3m.dartagnan.expression;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.google.common.collect.ImmutableSet;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class BConst extends BExpr implements ExprInterface {

	public final static BConst TRUE = new BConst(true);
	public final static BConst FALSE = new BConst(false);

	private final boolean value;
	
	public BConst(boolean value) {
		this.value = value;
	}

    @Override
	public BooleanFormula toBoolFormula(Event e, SolverContext ctx) {
		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		return value ? bmgr.makeTrue() : bmgr.makeFalse();
	}

	@Override
	public Formula getLastValueExpr(SolverContext ctx){
		IntegerFormulaManager imgr = ctx.getFormulaManager().getIntegerFormulaManager();
		return value ? imgr.makeNumber(BigInteger.ONE) : imgr.makeNumber(BigInteger.ZERO);
	}

    @Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}

	@Override
	public String toString() {
		return value ? "True" : "False";
	}

	@Override
	public boolean getBoolValue(Event e, Model model, SolverContext ctx){
		return value;
	}

	@Override
	public IConst reduce() {
		return value ? IConst.ONE : IConst.ZERO;
	}
	
	public boolean getValue() {
		return value;
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public int hashCode() {
		return Boolean.hashCode(value);
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {
			return true;
		}
		if (obj == null || obj.getClass() != getClass())
			return false;
		return ((BConst)obj).value == value;
	}
}
