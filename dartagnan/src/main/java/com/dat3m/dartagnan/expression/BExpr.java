package com.dat3m.dartagnan.expression;

import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

import java.math.BigInteger;

import com.dat3m.dartagnan.program.event.Event;

public abstract class BExpr implements ExprInterface {

    @Override
    public Expr toZ3Int(Event e, Context ctx) {
        return ctx.mkITE(toZ3Bool(e, ctx), ctx.mkInt(1), ctx.mkInt(0));
    }

    @Override
    public BigInteger getIntValue(Event e, Model model, Context ctx){
        return getBoolValue(e, model, ctx) ? BigInteger.ONE : BigInteger.ZERO;
    }
    
	@Override
	public int getPrecision() {
		throw new UnsupportedOperationException("getPrecision() not supported for " + this);
	}
	
	@Override
	public IExpr getBase() {
		return null;
	}

	public boolean isTrue() {
		return this.equals(BConst.TRUE);
	}

    public boolean isFalse() {
    	return this.equals(BConst.FALSE);
    }
}
