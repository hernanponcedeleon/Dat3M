package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class Assume extends Event implements RegReaderData {

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

	@Override
	public void initialise(VerificationTask task, Context ctx) {
		super.initialise(task, ctx);
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
	protected BoolExpr encodeExec(Context ctx){
		BoolExpr enc = super.encodeExec(ctx);
		enc = ctx.mkAnd(enc, ctx.mkEq(exec(), expr.toZ3Bool(this, ctx)));
		return enc;
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Assume getCopy(){
		return new Assume(this);
	}
}