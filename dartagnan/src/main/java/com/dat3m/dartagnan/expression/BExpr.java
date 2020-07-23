package com.dat3m.dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.event.Event;

public abstract class BExpr implements ExprInterface {

    @Override
    public Expr toZ3NumExpr(Event e, Context ctx, boolean bp) {
        return ctx.mkITE(toZ3Bool(e, ctx, bp),
				bp ? ctx.mkBV(1, 32) : ctx.mkInt(1),
				bp ? ctx.mkBV(0, 32) : ctx.mkInt(0));
    }

    @Override
    public int getIntValue(Event e, Context ctx, Model model, boolean bp){
        return getBoolValue(e, ctx, model, bp) ? 1 : 0;
    }
}
