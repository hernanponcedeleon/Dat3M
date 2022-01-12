package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.program.event.Tag;

public class Fence extends Event {

	protected final String name;

	public Fence(String name){
        this.name = name;
        this.addFilters(Tag.ANY, Tag.VISIBLE, Tag.FENCE, name);
	}

	protected Fence(Fence other){
		super(other);
		this.name = other.name;
	}

	public String getName(){
		return name;
	}

	@Override
	public String toString() {
		return getName();
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public Fence getCopy(){
		return new Fence(this);
	}
}
