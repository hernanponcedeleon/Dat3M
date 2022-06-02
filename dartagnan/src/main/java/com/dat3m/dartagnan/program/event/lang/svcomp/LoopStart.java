package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.annotations.FunCall;

public class LoopStart extends FunCall {

	public LoopStart() {
		super("__VERIFIER_loop_start");
	}
	
	protected LoopStart(LoopStart other) {
		super(other);
	}

	@Override
	public LoopStart getCopy() {
		return new LoopStart(this);
	}

}
