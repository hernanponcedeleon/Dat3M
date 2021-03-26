package com.dat3m.dartagnan.program.svcomp.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;

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