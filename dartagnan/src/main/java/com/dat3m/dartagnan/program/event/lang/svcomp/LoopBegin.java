package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.FunCall;

public class LoopBegin extends FunCall {

	public LoopBegin() {
		super("__VERIFIER_loop_begin");
	}
	
	protected LoopBegin(FunCall other) {
		super(other);
	}

}
