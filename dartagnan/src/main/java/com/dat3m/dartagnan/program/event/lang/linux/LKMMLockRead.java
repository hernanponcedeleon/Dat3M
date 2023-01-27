package com.dat3m.dartagnan.program.event.lang.linux;

import static com.dat3m.dartagnan.program.event.Tag.*;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Load;

public class LKMMLockRead extends Load {

	public LKMMLockRead(Register register, IExpr lock) {
		super(register, lock, Linux.MO_ACQUIRE);
		addFilters(RMW, Linux.LOCK_READ);
	}

	@Override
	public String toString() {
		return String.format("%s <- spin_lock_R(*%s)", resultRegister, address);
	}
}
