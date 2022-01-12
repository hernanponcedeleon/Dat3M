package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.utils.RegReaderData;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

public class Assume extends Event implements RegReaderData {

	protected final ExprInterface expr;
	private final ImmutableSet<Register> dataRegs;

	public Assume(ExprInterface expr) {
		super();
		this.expr = expr;
		this.dataRegs = expr.getRegs();
		addFilters(Tag.ANY, Tag.LOCAL, Tag.REG_READER);
	}

	protected Assume(Assume other){
		super(other);
		this.expr = other.expr;
		this.dataRegs = other.dataRegs;
	}


	public ExprInterface getExpr(){
		return expr;
	}


	@Override
	public ImmutableSet<Register> getDataRegs(){
		return dataRegs;
	}

    @Override
	public String toString() {
		return "assume(" + expr + ")";
	}

	@Override
	public BooleanFormula encodeExec(SolverContext ctx){
		BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
		BooleanFormula enc = super.encodeExec(ctx);
		enc = bmgr.and(enc, bmgr.implication(exec(), expr.toBoolFormula(this, ctx)));
		return enc;
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Assume getCopy(){
		return new Assume(this);
	}
}