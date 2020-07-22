package com.dat3m.dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.event.Event;
import static com.dat3m.dartagnan.utils.Settings.USEBV;

public abstract class BExpr implements ExprInterface {

    @Override
    public Expr toZ3NumExpr(Event e, Context ctx) {
        return ctx.mkITE(toZ3Bool(e, ctx),
				USEBV ? ctx.mkBV(1, 32) : ctx.mkInt(1),
				USEBV ? ctx.mkBV(0, 32) : ctx.mkInt(0));
    }

    @Override
    public int getIntValue(Event e, Context ctx, Model model){
        return getBoolValue(e, ctx, model) ? 1 : 0;
    }
}
