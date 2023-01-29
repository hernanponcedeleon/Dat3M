package com.dat3m.dartagnan.program.event.lang.linux;

import static com.dat3m.dartagnan.program.event.Tag.*;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.event.core.Store;

public class LKMMLockWrite extends Store {

	public LKMMLockWrite(IExpr lock) {
		super(lock, IValue.ONE, Linux.MO_ONCE);
		addFilters(RMW, Linux.LOCK_WRITE);
	}

	@Override
	public String toString() {
		return String.format("spin_lock_W(*%s)", address);
	}
}
