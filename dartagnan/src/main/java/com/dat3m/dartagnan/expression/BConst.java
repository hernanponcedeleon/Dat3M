package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.event.core.Event;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

public class BConst extends BExpr {

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
	public String toString() {
		return value ? "True" : "False";
	}

	@Override
	public boolean getBoolValue(Event e, Model model, SolverContext ctx){
		return value;
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
		} else if (obj == null || obj.getClass() != getClass()) {
			return false;
		}
		return ((BConst)obj).value == value;
	}
}
