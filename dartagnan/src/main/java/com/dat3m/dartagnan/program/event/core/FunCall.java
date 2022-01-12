package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.Tag;

public class FunCall extends Event {

	private final String funName;
	
	public FunCall(String funName) {
		this.funName = funName;
        addFilters(Tag.ANY);
	}
	
	protected FunCall(FunCall other){
		super(other);
		this.funName = other.funName;
	}

    @Override
    public String toString(){
        return "=== Calling " + funName + " ===";
    }

    public String getFunctionName() {
    	return funName;
    }

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public FunCall getCopy(){
		return new FunCall(this);
	}
}