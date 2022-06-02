package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.annotations.FunCall;

public class LoopEnd extends FunCall {

	public LoopEnd() {
		super("__VERIFIER_loop_end");
	}
	
	protected LoopEnd(LoopEnd other) {
		super(other);
	}

	@Override
	public LoopEnd getCopy() {
		return new LoopEnd(this);
	}

}
