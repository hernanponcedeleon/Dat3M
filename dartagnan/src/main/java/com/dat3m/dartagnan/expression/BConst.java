package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

import static com.dat3m.dartagnan.utils.Settings.USEBV;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class BConst extends BExpr implements ExprInterface {

	private final boolean value;
	
	public BConst(boolean value) {
		this.value = value;
	}

    @Override
	public BoolExpr toZ3Bool(Event e, Context ctx) {
		return value ? ctx.mkTrue() : ctx.mkFalse();
	}

	@Override
	public Expr getLastValueExpr(Context ctx){
		return value ? USEBV ? ctx.mkBV(1, 32) : ctx.mkInt(1) : USEBV ? ctx.mkBV(0, 32) : ctx.mkInt(0);
	}

    @Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}

	@Override
	public String toString() {
		return value ? "True" : "False";
	}

	@Override
	public boolean getBoolValue(Event e, Context ctx, Model model){
		return value;
	}

	@Override
	public IConst reduce() {
		return new IConst(value ? 1 : 0);
	}
	
	public boolean getValue() {
		return value;
	}
}
