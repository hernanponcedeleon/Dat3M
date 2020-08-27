package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

public class FunRet extends Event {

	String funName;
	
	public FunRet(String funName) {
		this.funName = funName;
        addFilters(EType.ANY);
	}
	
	protected FunRet(FunRet other){
		super(other);
		this.funName = other.funName;
	}

    @Override
    public String toString(){
        return "=== Returning from " + funName + "===";
    }

    public String getFunctionName() {
    	return funName;
    }

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public FunRet getCopy(){
		return new FunRet(this);
	}
}
