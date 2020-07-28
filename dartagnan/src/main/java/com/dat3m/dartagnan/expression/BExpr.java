package com.dat3m.dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;

public abstract class BExpr implements ExprInterface {

    @Override
    public Expr toZ3Int(Event e, EncodingConf conf) {
    	Context ctx = conf.getCtx();
    	boolean bp = conf.getBP();
        return ctx.mkITE(toZ3Bool(e, conf),
				bp ? ctx.mkBV(1, 32) : ctx.mkInt(1),
				bp ? ctx.mkBV(0, 32) : ctx.mkInt(0));
    }

    @Override
    public int getIntValue(Event e, Model model, EncodingConf conf){
        return getBoolValue(e, model, conf) ? 1 : 0;
    }
}
