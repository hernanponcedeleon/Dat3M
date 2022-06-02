package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LKMMFence extends Fence {

	public LKMMFence(String name) {
		super(name);
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLKMMFence(this);
	}
}
