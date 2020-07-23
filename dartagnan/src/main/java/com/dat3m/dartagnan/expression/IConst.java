package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class IConst extends IExpr implements ExprInterface {

	private final int value;
	
	public IConst(int value) {
		this.value = value;
	}

	@Override
	public Expr toZ3NumExpr(Event e, Context ctx, boolean bp) {
		return bp ? ctx.mkBV(value, 32) : ctx.mkInt(value);
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}

	@Override
	public String toString() {
		return  Integer.toString(value);
	}

	@Override
	public Expr getLastValueExpr(Context ctx, boolean bp){
		return bp ? ctx.mkBV(value, 32) : ctx.mkInt(value);
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model, boolean bp){
		return value;
	}

    public Expr toZ3NumExpr(Context ctx, boolean bp) {
		return bp ? ctx.mkBV(value, 32) : ctx.mkInt(value);
    }

	@Override
	public IConst reduce() {
		return this;
	}
	
	public int getValue() {
		return value;
	}
}
