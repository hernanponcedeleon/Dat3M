package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

public class BoundEvent extends Event {

	public BoundEvent() {
		super();
		addFilters(EType.BASSERTION);
	}
}
