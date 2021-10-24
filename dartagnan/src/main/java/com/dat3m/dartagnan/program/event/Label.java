package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;

public class Label extends Event {

    private final String name;
    
    public Label(String name){
        this.name = name;
        addFilters(EType.ANY, EType.LABEL);
    }

    protected Label(Label other){
		super(other);
        this.name = other.name;
    }

    public String getName(){
        return name;
    }

    @Override
    public String toString(){
        return name + ":";
    }

    @Override
    protected RecursiveAction simplifyRecursive(Event predecessor, int depth) {
        Event prev = this;
        Event next = successor;
        if(listeners.size() == 0 && !name.startsWith("END_OF_T")) {
            prev = predecessor;
            predecessor.setSuccessor(successor);
        }
        if(next != null){
            if (depth < GlobalSettings.getInstance().getMaxRecursionDepth()) {
                return next.simplifyRecursive(prev, depth + 1);
            } else {
                Event finalPrev = prev;
                return RecursiveAction.call(() -> next.simplifyRecursive(finalPrev, 0));
            }
        }
        return RecursiveAction.done();
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Label getCopy(){
    	Label copy = new Label(this);
    	if (this.equals(getThread().getExit())) {
    	    getThread().updateExit(copy);
        }
    	for(Event jump : listeners) {
    		jump.notify(copy);
    	}
    	return copy;
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------


}
