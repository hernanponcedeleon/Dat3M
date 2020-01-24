package com.dat3m.dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;

public class INonDet extends IExpr implements ExprInterface {
	
	private boolean signed = true;
	
	public INonDet(boolean signed) {
		this.signed = signed;
	}

	@Override
	public IConst reduce() {
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public IntExpr toZ3Int(Event e, Context ctx) {
		return ctx.mkIntConst(this.toString());
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx) {
		return ctx.mkIntConst(this.toString());
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model) {
		return Integer.parseInt(model.getConstInterp(toZ3Int(e, ctx)).toString());
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}
	
	@Override
	public String toString() {
		return signed? "nondet_int()" : "nondet_uint()";
	}
	
	public boolean isSigned() {
		return signed;
	}
}
