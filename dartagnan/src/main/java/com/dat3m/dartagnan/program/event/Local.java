package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;

public class Local extends Event implements RegWriter, RegReaderData {
	
	protected final Register register;
	protected final ExprInterface expr;
	private final ImmutableSet<Register> dataRegs;
	private Expr regResultExpr;
	
	public Local(Register register, ExprInterface expr) {
		this.register = register;
		this.expr = expr;
		this.dataRegs = expr.getRegs();
		addFilters(EType.ANY, EType.LOCAL, EType.REG_WRITER, EType.REG_READER);
	}

	protected Local(Local other){
		super(other);
		this.register = other.register;
		this.expr = other.expr;
		this.dataRegs = other.dataRegs;
		this.regResultExpr = other.regResultExpr;
	}

	@Override
	public void initialise(Context ctx) {
		super.initialise(ctx);
		regResultExpr = register.toZ3IntResult(this, ctx);
	}

	public ExprInterface getExpr(){
		return expr;
	}

	@Override
	public Register getResultRegister(){
		return register;
	}

	@Override
	public Expr getResultRegisterExpr(){
		return regResultExpr;
	}

	@Override
	public ImmutableSet<Register> getDataRegs(){
		return dataRegs;
	}

    @Override
	public String toString() {
		return register + " <- " + expr;
	}

	@Override
	protected BoolExpr encodeExec(Context ctx){
		BoolExpr enc = super.encodeExec(ctx);
		Expr exprEnc = expr.toZ3Int(this, ctx);
		if(expr instanceof INonDet) {
			INonDet iNonDet = (INonDet)expr;
			if(exprEnc.isBV()) {
	        	enc = ctx.mkAnd(enc, ctx.mkBVSGE((BitVecExpr)exprEnc, ctx.mkBV(iNonDet.getMin(), iNonDet.getPrecision())));
	        	enc = ctx.mkAnd(enc, ctx.mkBVSLE((BitVecExpr)exprEnc, ctx.mkBV(iNonDet.getMax(), iNonDet.getPrecision())));					
			} else {
	        	enc = ctx.mkAnd(enc, ctx.mkGe((IntExpr)exprEnc, ctx.mkInt(iNonDet.getMin())));
	        	enc = ctx.mkAnd(enc, ctx.mkLe((IntExpr)exprEnc, ctx.mkInt(iNonDet.getMax())));
			}
		}
		return ctx.mkAnd(enc, ctx.mkEq(regResultExpr,  exprEnc));
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Local getCopy(){
		return new Local(this);
	}
}