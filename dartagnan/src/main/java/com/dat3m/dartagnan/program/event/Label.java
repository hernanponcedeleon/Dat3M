package com.dat3m.dartagnan.program.event;

import java.util.HashSet;

import com.dat3m.dartagnan.program.utils.EType;

public class Label extends Event {

    private final String name;
    
    public Label(String name){
        this.name = name;
        addFilters(EType.ANY);
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

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Label getCopy(){
    	Label copy = new Label(this);
    	for(Event jump : references) {
    		jump.updateReference(copy);
    	}
    	references = new HashSet<>();
        return copy;
    }
}
