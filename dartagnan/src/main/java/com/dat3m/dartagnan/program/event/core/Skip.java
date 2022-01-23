package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class Skip extends Event {
	
	public Skip() {
		addFilters(Tag.ANY);
	}

	protected Skip(Skip other){
		super(other);
	}

	@Override
	public String toString() {
		return "skip";
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Skip getCopy(){
		return new Skip(this);
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitSkip(this);
	}
}