package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.utils.EType;

public class Assertion extends Local {

	public Assertion(Register register, ExprInterface expr) {
		super(register, expr);
		addFilters(EType.ANY, EType.LOCAL, EType.REG_WRITER, EType.REG_READER, EType.ASSERTION);
	}
	
	protected Assertion(Assertion other){
		super(other);
	}

	@Override
	public Assertion getCopy(){
		return new Assertion(this);
	}
}
