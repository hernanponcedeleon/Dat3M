package com.dat3m.dartagnan.expression;

import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;

import static com.dat3m.dartagnan.utils.Settings.USEBV;

import com.dat3m.dartagnan.program.event.Event;

public abstract class IExpr implements ExprInterface {

    @Override
	public BoolExpr toZ3Bool(Event e, Context ctx) {
   		return USEBV ? ctx.mkBVSGT((BitVecExpr)toZ3NumExpr(e, ctx), ctx.mkBV(0, 32)) : ctx.mkGt((IntExpr)toZ3NumExpr(e, ctx), ctx.mkInt(0));	
	}

    @Override
    public boolean getBoolValue(Event e, Context ctx, Model model){
        return getIntValue(e, ctx, model) > 0;
    }
}
