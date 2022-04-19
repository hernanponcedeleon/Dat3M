package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.FunCall;

public class LoopStart extends FunCall {

	public LoopStart() {
		super("__VERIFIER_loop_start");
	}
	
	protected LoopStart(FunCall other) {
		super(other);
	}

}
