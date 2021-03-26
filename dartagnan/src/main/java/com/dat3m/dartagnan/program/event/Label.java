package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

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
    public void simplify(Event predecessor) {
    	Event prev = this;
    	Event next = successor;
    	if(listeners.size() == 0) {
    		prev = predecessor;
    		predecessor.setSuccessor(successor);
    	}
    	if(next != null){
			next.simplify(prev);
		}
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
}
