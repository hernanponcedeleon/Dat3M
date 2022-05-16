package com.dat3m.dartagnan.program.event.lang.linux;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class LKMMLock extends Event {

	private IExpr lock;
	
	public LKMMLock(IExpr lock) {
		this.lock = lock;
	}

	public IExpr getLock() {
		return lock;
	}
	
	@Override
	public String toString() {
		return String.format("spin_lock(*%s)", lock);
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLKMMLock(this);
	}
}
