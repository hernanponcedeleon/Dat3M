package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.program.expression.Expression;

import static com.dat3m.dartagnan.program.event.Tag.Linux;
import static com.dat3m.dartagnan.program.event.Tag.RMW;

public class LKMMLockWrite extends RMWStore {

	public LKMMLockWrite(Load lockRead, Expression lock) {
		super(lockRead, lock, IValue.ONE, Linux.MO_ONCE);
		addFilters(RMW, Linux.LOCK_WRITE);
	}

	@Override
	public String toString() {
		return String.format("spin_lock_W(*%s)", address);
	}
}
