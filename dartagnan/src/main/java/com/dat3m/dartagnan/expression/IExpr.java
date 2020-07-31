package com.dat3m.dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.event.Event;

public abstract class IExpr implements ExprInterface {

    @Override
	public BoolExpr toZ3Bool(Event e, Context ctx) {
   		return ctx.mkGt((IntExpr)toZ3Int(e, ctx), ctx.mkInt(0));	
	}

    @Override
    public boolean getBoolValue(Event e, Model model, Context ctx){
        return getIntValue(e, model, ctx) > 0;
    }
}
