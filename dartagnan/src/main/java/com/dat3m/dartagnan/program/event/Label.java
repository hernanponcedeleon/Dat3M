package com.dat3m.dartagnan.program.event;

import java.util.HashSet;
import java.util.Set;

import com.dat3m.dartagnan.program.utils.EType;

public class Label extends Event {

    private final String name;
    private Set<Jump> references = new HashSet<>();
    
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

    public void addReference(Jump jump) {
    	references.add(jump);
    }
    
    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Label getCopy(){
    	Label copy = new Label(this);
    	for(Jump jump : references) {
    		jump.updateLabel(copy);
    	}
    	references = new HashSet<>();
        return copy;
    }
}
