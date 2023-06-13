package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Load;

import static com.dat3m.dartagnan.program.event.Tag.Linux;
import static com.dat3m.dartagnan.program.event.Tag.RMW;

// FIXME: We inherit from Load to keep this a core event.
//  We keep this a core event just to get a better toString implementation
public class LKMMLockRead extends Load {

	public LKMMLockRead(Register register, Expression lock) {
		super(register, lock);
		addTags(RMW, Linux.LOCK_READ, Linux.MO_ACQUIRE);
	}

	@Override
	public String toString() {
		return String.format("%s <- spin_lock_R(*%s)", resultRegister, address);
	}
}
