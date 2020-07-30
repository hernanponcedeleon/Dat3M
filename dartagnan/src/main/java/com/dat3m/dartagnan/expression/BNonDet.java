package com.dat3m.dartagnan.expression;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;
import com.google.common.collect.ImmutableSet;

public class BNonDet extends BExpr implements ExprInterface {

	@Override
	public IConst reduce() {
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public BoolExpr toZ3Bool(Event e, EncodingConf conf) {
		return conf.getCtx().mkBoolConst(Integer.toString(hashCode()));
	}

	@Override
	public Expr getLastValueExpr(EncodingConf conf) {
		throw new UnsupportedOperationException("getLastValueExpr not supported for " + this);
	}

	@Override
	public boolean getBoolValue(Event e, Model model, EncodingConf conf) {
		return model.getConstInterp(toZ3Int(e, conf)).isTrue();
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
	}

	@Override
	public String toString() {
		return "nondet_bool()";
	}

	@Override
	public int getPrecision() {
		throw new UnsupportedOperationException("getPrecision() not supported for " + this);
	}
}
