package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.GlobalFlags;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
import com.dat3m.dartagnan.wmm.utils.Arch;

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

    /*@Override
    public void simplify(Event predecessor) {
    	Event prev = this;
    	Event next = successor;
    	if(listeners.size() == 0 && !name.startsWith("END_OF_T")) {
    		prev = predecessor;
    		predecessor.setSuccessor(successor);
    	}
    	if(next != null){
			next.simplify(prev);
		}
    }*/

    @Override
    protected RecursiveAction simplifyRecursive(Event predecessor, int depth) {
        Event prev = this;
        Event next = successor;
        if(listeners.size() == 0 && !name.startsWith("END_OF_T")) {
            prev = predecessor;
            predecessor.setSuccessor(successor);
        }
        if(next != null){
            if (depth < GlobalFlags.MAX_RECURSION_DEPTH) {
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
    	for(Event jump : listeners) {
    		jump.notify(copy);
    	}
    	return copy;
    }

    /*@Override
    public void unroll(int bound, Event predecessor) {
    	super.unroll(bound, predecessor);
    	for(Event jump : listeners) {
    		jump.notify(this);
    	}
    }*/

    @Override
    public RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
        return super.unrollRecursive(bound, predecessor, depth).then( () -> {
            for (Event jump : listeners) {
                jump.notify(this);
            }
        });
    }

    // Compilation
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public int compile(Arch target, int nextId, Event predecessor) {
    	nextId = super.compile(target, nextId, predecessor);
    	for(Event jump : listeners) {
    		jump.notify(this);
    	}
    	return nextId;
    }

}
