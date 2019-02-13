package com.dat3m.dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.event.Event;

public abstract class BExpr implements ExprInterface {

    @Override
    public IntExpr toZ3Int(Event e, Context ctx) {
        return (IntExpr) ctx.mkITE(toZ3Bool(e, ctx), ctx.mkInt(1), ctx.mkInt(0));
    }

    @Override
    public abstract BExpr clone();

    @Override
    public int getIntValue(Event e, Context ctx, Model model){
        return getBoolValue(e, ctx, model) ? 1 : 0;
    }
}
