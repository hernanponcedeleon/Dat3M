package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

public class Local extends Event implements RegWriter, RegReaderData {
	
	protected Register reg;
	protected ExprInterface expr;
	private IntExpr regResultExpr;
	private ImmutableSet<Register> dataRegs;
	
	public Local(Register reg, ExprInterface expr) {
		this.reg = reg;
		this.expr = expr;
		this.condLevel = 0;
		dataRegs = expr.getRegs();
		addFilters(EType.ANY, EType.LOCAL, EType.REG_WRITER, EType.REG_READER);
	}

	@Override
	public void initialise(Context ctx) {
		regResultExpr = reg.toZ3IntResult(this, ctx);
	}

	public ExprInterface getExpr(){
		return expr;
	}

	@Override
	public Register getResultRegister(){
		return reg;
	}

	@Override
	public IntExpr getResultRegisterExpr(){
		return regResultExpr;
	}

	@Override
	public ImmutableSet<Register> getDataRegs(){
		return dataRegs;
	}

    @Override
	public String toString() {
		return nTimesCondLevel() + reg + " <- " + expr;
	}

    @Override
	public Local clone() {
	    if(clone == null){
            clone = new Local(reg, expr);
            afterClone();
        }
		return (Local)clone;
	}

	@Override
	public BoolExpr encodeCF(Context ctx) {
		return ctx.mkAnd(super.encodeCF(ctx), ctx.mkEq(regResultExpr,  expr.toZ3Int(this, ctx)));
	}
}