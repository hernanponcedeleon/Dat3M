package com.dat3m.dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Model;

import com.dat3m.dartagnan.program.event.Event;

public abstract class IExpr implements ExprInterface {

    @Override
	public BoolExpr toZ3Bool(Event e, Context ctx) {
		return ctx.mkGt(toZ3Int(e, ctx), ctx.mkInt(0));
	}

    @Override
    public boolean getBoolValue(Event e, Context ctx, Model model){
        return getIntValue(e, ctx, model) > 0;
    }
}
