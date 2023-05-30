package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Load;

import static com.dat3m.dartagnan.program.event.Tag.Linux;
import static com.dat3m.dartagnan.program.event.Tag.RMW;

public class LKMMLockRead extends Load {

	public LKMMLockRead(Register register, ExprInterface lock) {
		super(register, lock, Linux.MO_ACQUIRE);
		addTags(RMW, Linux.LOCK_READ);
	}

	@Override
	public String toString() {
		return String.format("%s <- spin_lock_R(*%s)", resultRegister, address);
	}
}
