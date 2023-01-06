package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;

public class SpinEnd extends CodeAnnotation {

	public SpinEnd() { }
	
	protected SpinEnd(SpinEnd other) {
		super(other);
	}

	@Override
	public SpinEnd getCopy() {
		return new SpinEnd(this);
	}

	@Override
	public String toString() {
		return "#__VERIFIER_spin_end";
	}

}
