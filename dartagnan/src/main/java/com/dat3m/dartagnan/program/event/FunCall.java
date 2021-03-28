package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

public class FunCall extends Event {

	String funName;
	
	public FunCall(String funName, int cLine) {
		super(cLine);
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
    
    @Override
    public void simplify(Event predecessor) {
    	Event prev = this;
    	Event next = successor;
    	if(successor instanceof FunRet && ((FunRet)successor).getFunctionName().equals(funName)) {
    		prev = predecessor;
    		next = successor.getSuccessor();
    		predecessor.setSuccessor(next);
    	}
		if(next != null){
			next.simplify(prev);
		}
    }

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public FunCall getCopy(){
		return new FunCall(this);
	}
}
