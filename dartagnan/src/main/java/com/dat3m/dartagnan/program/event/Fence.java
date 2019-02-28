package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;

public class Fence extends Event {

	protected final String name;

	public Fence(String name){
        this.name = name;
        this.addFilters(EType.ANY, EType.VISIBLE, EType.FENCE, name);
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

	@Override
	public String label(){
		return getName();
	}

	// Unrolling
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	protected Fence mkCopy(){
		return new Fence(this);
	}
}
