package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

public class Label extends Event {

    private final String name;
    private int copy = 0;
    private Label currentCopy = this;

    public Label(String name){
        this.name = name;
        addFilters(EType.ANY);
    }

	protected Label(Label other, int copy){
		super(other);
		this.name = other.name + "_" + copy;
	}

    public String getName(){
        return name;
    }

    @Override
    public String toString(){
        return name + ":";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Label getCopy(){
        throw new UnsupportedOperationException("Cloning is not implemented for Label event");
    }

    public Label getCopy(boolean update){
    	if(update) {
        	copy++;
        	currentCopy = new Label(this, copy);    		
    	}
    	return currentCopy;
    }
}
