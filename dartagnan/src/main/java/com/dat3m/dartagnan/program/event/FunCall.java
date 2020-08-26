package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

public class FunCall extends Event {

	String funName;
	
	public FunCall(String funName) {
		this.funName = funName;
        addFilters(EType.ANY);
	}
	
	protected FunCall(FunCall other){
		super(other);
		this.funName = other.funName;
	}

    @Override
    public String toString(){
        return "=== Calling " + funName + "===";
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
