package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.annotations.FunCall;

public class LoopBegin extends FunCall {

	public LoopBegin() {
		super("__VERIFIER_loop_begin");
	}
	
	protected LoopBegin(LoopBegin other) {
		super(other);
	}

	@Override
	public LoopBegin getCopy() {
		return new LoopBegin(this);
	}

}
