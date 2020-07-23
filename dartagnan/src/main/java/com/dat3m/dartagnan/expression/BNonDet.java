package com.dat3m.dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;

public class BNonDet extends BExpr implements ExprInterface {

	@Override
	public IConst reduce() {
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public BoolExpr toZ3Bool(Event e, Context ctx, boolean bp) {
		return ctx.mkBoolConst(Integer.toString(hashCode()));
	}

	@Override
	public Expr getLastValueExpr(Context ctx, boolean bp) {
		throw new UnsupportedOperationException("getLastValueExpr not supported for " + this);
	}

	@Override
	public boolean getBoolValue(Event e, Context ctx, Model model, boolean bp) {
		return model.getConstInterp(toZ3NumExpr(e, ctx, bp)).isTrue();
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
