package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;

public class LoopEnd extends CodeAnnotation {

	public LoopEnd() { }
	
	protected LoopEnd(LoopEnd other) {
		super(other);
	}

	@Override
	public LoopEnd getCopy() {
		return new LoopEnd(this);
	}

	@Override
	public String toString() {
		return "#__VERIFIER_loop_end";
	}

}
