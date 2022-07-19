package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;

public class LoopBegin extends CodeAnnotation {

	public LoopBegin() { }
	
	protected LoopBegin(LoopBegin other) {
		super(other);
	}

	@Override
	public LoopBegin getCopy() {
		return new LoopBegin(this);
	}

	@Override
	public String toString() {
		return "#__VERIFIER_loop_begin";
	}
}
