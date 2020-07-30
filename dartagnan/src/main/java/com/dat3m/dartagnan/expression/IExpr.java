package com.dat3m.dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;

public abstract class IExpr implements ExprInterface {

    @Override
	public BoolExpr toZ3Bool(Event e, EncodingConf conf) {
    	Context ctx = conf.getCtx();
   		return ctx.mkGt((IntExpr)toZ3Int(e, conf), ctx.mkInt(0));	
	}

    @Override
    public boolean getBoolValue(Event e, Model model, EncodingConf conf){
        return getIntValue(e, model, conf) > 0;
    }
}
