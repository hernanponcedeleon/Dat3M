package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.core.annotations.FunCall;

public class LoopBound extends FunCall {

	protected int bound = 0;

	public int getBound() { return bound; }

	public LoopBound(int bound) {
		super("__VERIFIER_loop_bound");
		this.bound = bound;
	}

	protected LoopBound(LoopBound other) {
		super(other);
		this.bound = other.bound;
	}

	@Override
	public String toString() {
		return String.format("=== Calling %s(%s) ===", getFunctionName(), getBound());
	}

	@Override
	public LoopBound getCopy() {
		return new LoopBound(this);
	}
}
