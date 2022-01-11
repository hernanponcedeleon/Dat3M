package com.dat3m.dartagnan.program.event.lang.svcomp;

import com.dat3m.dartagnan.program.event.EType;
import com.dat3m.dartagnan.program.event.core.Event;

public class BeginAtomic extends Event {
	
    public BeginAtomic() {
        addFilters(EType.RMW);
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
		BeginAtomic copy = new BeginAtomic(this);
    	for(Event end : listeners) {
    		end.notify(copy);
    	}
		return copy;
	}
}