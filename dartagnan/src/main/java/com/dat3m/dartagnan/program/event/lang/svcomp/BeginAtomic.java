package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class BeginAtomic extends Event {
	
    public BeginAtomic() {
        addTags(Tag.RMW);
    }

    protected BeginAtomic(BeginAtomic other){
		super(other);
	}

    @Override
    public String toString() {
    	return "begin_atomic()";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

	@Override
	public BeginAtomic getCopy(){
		return new BeginAtomic(this);
	}

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitBeginAtomic(this);
	}
}