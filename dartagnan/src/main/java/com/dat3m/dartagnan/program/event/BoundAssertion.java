package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.BConst;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.utils.EType;

public class BoundAssertion extends Local {

	public BoundAssertion(Register register) {
		super(register, new BConst(false));
		addFilters(EType.BASSERTION);
	}
}
