package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.utils.EType;

public class Lock extends Event {

    public Lock() {
        addFilters(EType.LOCK);
    }

    protected Lock(Lock other){
		super(other);
	}

    @Override
    public String toString() {
    	return "lock()";
    }
    
	@Override
	public Lock getCopy(){
		return new Lock(this);
	}
}
