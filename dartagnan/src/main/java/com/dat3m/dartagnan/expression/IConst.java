package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;

public class IConst extends IExpr implements ExprInterface {

	private final int value;
	protected final int precision;
	
	public IConst(int value, int precision) {
		this.value = value;
		this.precision = precision;
	}

	@Override
	public Expr toZ3Int(Event e, EncodingConf conf) {
		Context ctx = conf.getCtx();
		return precision > 0 ? ctx.mkBV(value, 32) : ctx.mkInt(value);
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}

	@Override
	public String toString() {
		return Integer.toString(value);
	}

	@Override
	public Expr getLastValueExpr(EncodingConf conf){
		Context ctx = conf.getCtx();
		return precision > 0 ? ctx.mkBV(value, 32) : ctx.mkInt(value);
	}

	@Override
	public int getIntValue(Event e, Model model, EncodingConf conf){
		return value;
	}

    public Expr toZ3Int(EncodingConf conf) {
    	Context ctx = conf.getCtx();
		return precision > 0 ? ctx.mkBV(value, 32) : ctx.mkInt(value);
    }

	@Override
	public IConst reduce() {
		return this;
	}
	
	public int getValue() {
		return value;
	}
    
	@Override
	public int getPrecision() {
    	return precision;
    }
}
