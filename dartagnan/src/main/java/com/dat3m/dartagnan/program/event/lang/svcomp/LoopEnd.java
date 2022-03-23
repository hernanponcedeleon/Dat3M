package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.FunCall;

public class LoopEnd extends FunCall {

	public LoopEnd() {
		super("__VERIFIER_loop_end");
	}
	
	protected LoopEnd(FunCall other) {
		super(other);
	}

}
