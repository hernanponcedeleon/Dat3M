package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;

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
        return "=== Calling " + funName + " ===";
    }

    public String getFunctionName() {
    	return funName;
    }

	@Override
	public RecursiveAction simplifyRecursive(Event predecessor, int depth) {
		Event prev = this;
		Event next = successor;
		if(successor instanceof FunRet && ((FunRet)successor).getFunctionName().equals(funName)) {
			prev = predecessor;
			next = successor.getSuccessor();
			predecessor.setSuccessor(next);
		}
		if(next != null){
			if (depth < GlobalSettings.MAX_RECURSION_DEPTH) {
				return next.simplifyRecursive(prev, depth + 1);
			} else {
				Event finalNext = next;
				Event finalPrev = prev;
				return RecursiveAction.call(() -> finalNext.simplifyRecursive(finalPrev, 0));
			}
		}
		return RecursiveAction.done();
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public FunCall getCopy(){
		return new FunCall(this);
	}
}
