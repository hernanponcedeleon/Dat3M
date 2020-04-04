package com.dat3m.dartagnan.program.event.rmw;

import java.util.HashSet;
import java.util.Set;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;

public class BeginAtomic extends Event {
	
	private Set<EndAtomic> references = new HashSet<>();

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

    public void addReference(EndAtomic e) {
    	references.add(e);
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

	@Override
	public BeginAtomic getCopy(){
		BeginAtomic copy = new BeginAtomic(this);
    	for(EndAtomic end : references) {
    		end.updateLabel(copy);
    	}
		return copy;
	}
}
