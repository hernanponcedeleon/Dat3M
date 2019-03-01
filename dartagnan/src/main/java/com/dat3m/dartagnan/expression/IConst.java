package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class IConst extends IExpr implements ExprInterface {

	private final int value;
	
	public IConst(int value) {
		this.value = value;
	}

	@Override
	public IntExpr toZ3Int(Event e, Context ctx) {
		return ctx.mkInt(value);
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}

	@Override
	public String toString() {
		return Integer.toString(value);
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx){
		return ctx.mkInt(value);
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model){
		return value;
	}

    public IntExpr toZ3Int(Context ctx) {
        return ctx.mkInt(value);
    }
}
