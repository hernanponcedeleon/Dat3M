package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

public class Label extends Event {

    private final String name;

    public Label(String name){
        this.name = name;
        addFilters(EType.ANY);
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
    public Label getCopy(int bound){
    	return new Label(name + "_" + bound);
        //throw new UnsupportedOperationException("Cloning is not implemented for Label event");
    }
}
