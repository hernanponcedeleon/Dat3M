package com.dat3m.dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;

public class BNonDet extends BExpr implements ExprInterface {

	private final int precision;
	
	public BNonDet(int precision) {
		this.precision = precision;
	}
	
	@Override
	public IConst reduce() {
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

    @Override
    public Expr toZ3Int(Event e, Context ctx) {
    	Expr e1 = precision > 0 ? ctx.mkBV(1, precision) : ctx.mkInt(1);
    	Expr e2 = precision > 0 ? ctx.mkBV(0, precision) : ctx.mkInt(0);
        return ctx.mkITE(toZ3Bool(e, ctx), e1, e2);
    }

	@Override
	public BoolExpr toZ3Bool(Event e, Context ctx) {
		return ctx.mkBoolConst(Integer.toString(hashCode()));
	}

	@Override
	public Expr getLastValueExpr(Context ctx) {
		throw new UnsupportedOperationException("getLastValueExpr not supported for " + this);
	}

	@Override
	public boolean getBoolValue(Event e, Model model, Context ctx) {
		return model.getConstInterp(toZ3Int(e, ctx)).isTrue();
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}

	@Override
	public String toString() {
		return "nondet_bool()";
	}
}
