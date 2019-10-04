package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;

public class Unlock extends Event {

    public Unlock() {
        addFilters(EType.LOCK);
    }

    protected Unlock(Unlock other){
		super(other);
	}

    @Override
    public String toString() {
    	return "unlock()";
    }
    
	@Override
	public Unlock getCopy(){
		return new Unlock(this);
	}
}
