package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

public class Assume extends Event implements RegReaderData {

	protected final ExprInterface expr;

	public Assume(ExprInterface expr) {
		super();
		this.expr = expr;
		addFilters(Tag.ANY, Tag.LOCAL, Tag.REG_READER);
	}

	protected Assume(Assume other){
		super(other);
		this.expr = other.expr;
	}


	public ExprInterface getExpr(){
		return expr;
	}


	@Override
	public ImmutableSet<Register> getDataRegs(){
		return expr.getRegs();
	}

    @Override
	public String toString() {
		return "assume(" + expr + ")";
	}

	@Override
	public BooleanFormula encodeExec(EncodingContext ctx) {
		BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
		BooleanFormula enc = super.encodeExec(ctx);
		enc = bmgr.and(enc, bmgr.implication(ctx.execution(this), expr.toBoolFormula(this, ctx.getSolverContext())));
		return enc;
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