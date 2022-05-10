package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;

public class Label extends Event {

    private String name;
    
    public Label(String name){
        this.name = name;
        addFilters(Tag.ANY, Tag.LABEL);
    }

    protected Label(Label other){
		super(other);
        this.name = other.name;
    }

    public String getName(){ return name; }
    public void setName(String name) { this.name = name;}

    @Override
    public String toString(){
        return name + ":";
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Label getCopy(){
    	return new Label(this);
    }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitLabel(this);
	}
}