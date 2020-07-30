package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;

public class BConst extends BExpr implements ExprInterface {

	private final boolean value;
	private final int precision;
	
	public BConst(boolean value, int precision) {
		this.value = value;
		this.precision = precision;
	}

    @Override
	public BoolExpr toZ3Bool(Event e, EncodingConf conf) {
    	Context ctx = conf.getCtx();
		return value ? ctx.mkTrue() : ctx.mkFalse();
	}

	@Override
	public Expr getLastValueExpr(EncodingConf conf){
		Context ctx = conf.getCtx();
		return value ? ctx.mkInt(1) : ctx.mkInt(0);
	}

    @Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}

	@Override
	public String toString() {
		return value ? "True" : "False";
	}

	@Override
	public boolean getBoolValue(Event e, Model model, EncodingConf conf){
		return value;
	}

	@Override
	public IConst reduce() {
		return new IConst(value ? 1 : 0, precision);
	}
	
	public boolean getValue() {
		return value;
	}

	@Override
	public int getPrecision() {
		return precision;
	}
}
