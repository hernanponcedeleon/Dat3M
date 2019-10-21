package com.dat3m.dartagnan.program.event.rmw;

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
    
	@Override
	public BeginAtomic getCopy(){
		return new BeginAtomic(this);
	}
}
