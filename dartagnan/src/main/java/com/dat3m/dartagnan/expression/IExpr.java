package com.dat3m.dartagnan.expression;

import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.event.Event;

public abstract class IExpr implements ExprInterface {

    @Override
	public BoolExpr toZ3Bool(Event e, Context ctx, boolean bp) {
   		return bp ? ctx.mkBVSGT((BitVecExpr)toZ3NumExpr(e, ctx, bp), ctx.mkBV(0, 32)) : ctx.mkGt((IntExpr)toZ3NumExpr(e, ctx, bp), ctx.mkInt(0));	
	}

    @Override
    public boolean getBoolValue(Event e, Context ctx, Model model, boolean bp){
        return getIntValue(e, ctx, model, bp) > 0;
    }
}
