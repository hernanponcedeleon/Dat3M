package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;

public class LoopStart extends CodeAnnotation {

	public LoopStart() { }
	
	protected LoopStart(LoopStart other) {
		super(other);
	}

	@Override
	public LoopStart getCopy() {
		return new LoopStart(this);
	}

	@Override
	public String toString() {
		return "#__VERIFIER_loop_start";
	}

}
