package com.dat3m.dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.event.Event;

public abstract class BExpr implements ExprInterface {

    @Override
    public Expr toZ3Int(Event e, Context ctx) {
        return ctx.mkITE(toZ3Bool(e, ctx), ctx.mkInt(1), ctx.mkInt(0));
    }

    @Override
    public long getIntValue(Event e, Model model, Context ctx){
        return getBoolValue(e, model, ctx) ? 1 : 0;
    }
    
	@Override
	public int getPrecision() {
		throw new UnsupportedOperationException("getPrecision() not supported for " + this);
	}
	
	@Override
	public IExpr getBase() {
		return null;
	}

	public boolean isTrue() { return (this instanceof BConst) && ((BConst)this).getValue(); }

    public boolean isFalse() { return (this instanceof BConst) && !((BConst)this).getValue(); }
}
