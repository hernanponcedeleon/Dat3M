package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.HashSet;
import java.util.Set;

public class Assume extends AbstractEvent implements RegReader {

	protected final ExprInterface expr;

	public Assume(ExprInterface expr) {
		super();
		this.expr = expr;
	}

	protected Assume(Assume other){
		super(other);
		this.expr = other.expr;
	}


	public ExprInterface getExpr(){
		return expr;
	}


	@Override
	public Set<Register.Read> getRegisterReads() {
		return Register.collectRegisterReads(expr, Register.UsageType.OTHER, new HashSet<>());
	}

    @Override
	public String toString() {
		return "assume(" + expr + ")";
	}

	@Override
	public BooleanFormula encodeExec(EncodingContext ctx) {
		BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
		return bmgr.and(
				super.encodeExec(ctx),
				bmgr.implication(ctx.execution(this), ctx.encodeBooleanExpressionAt(expr, this)));
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Assume getCopy(){
		return new Assume(this);
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitAssume(this);
	}
}