package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;

public class Assume extends AbstractEvent implements RegReaderData {

	protected final ExprInterface expr;
	private final ImmutableSet<Register> dataRegs;

	public Assume(ExprInterface expr) {
		super();
		this.expr = expr;
		this.dataRegs = expr.getRegs();
		addFilters(EType.ANY, EType.LOCAL, EType.REG_READER);
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