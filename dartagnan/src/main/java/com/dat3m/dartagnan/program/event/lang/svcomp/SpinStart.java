package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;

public class SpinStart extends CodeAnnotation {

	public SpinStart() { }
	
	protected SpinStart(SpinStart other) {
		super(other);
	}

	@Override
	public SpinStart getCopy() {
		return new SpinStart(this);
	}

	@Override
	public String toString() {
		return "#__VERIFIER_spin_start";
	}

}
