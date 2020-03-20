package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class DummyExpr extends IExpr {

	@Override
	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public IntExpr toZ3Int(Event e, Context ctx) {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx) {
		throw new UnsupportedOperationException("Reduce not supported for " + this);	
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model) {
		throw new UnsupportedOperationException("Reduce not supported for " + this);	
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public IExpr getBaseAddress() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public boolean equals(Object e) {
		return e instanceof DummyExpr;
	}
}
