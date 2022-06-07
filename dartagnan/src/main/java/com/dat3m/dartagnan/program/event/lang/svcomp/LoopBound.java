package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.annotations.CodeAnnotation;
import com.google.common.base.Preconditions;

public class LoopBound extends CodeAnnotation {

	private final int bound;

	public int getBound() { return bound; }

	public LoopBound(int bound) {
		Preconditions.checkArgument(bound > 0, "The provided loop bound '%s' must be positive.", bound);
		this.bound = bound;
	}

	protected LoopBound(LoopBound other) {
		super(other);
		this.bound = other.bound;
	}

	@Override
	public String toString() {
		return String.format("#__VERIFIER_loop_bound(%s)", bound);
	}

	@Override
	public LoopBound getCopy() {
		return new LoopBound(this);
	}
}
