package com.dat3m.dartagnan.boogie;

public class Scope {

	private final int id;
	private final Scope parent;
	
	public Scope(int id, Scope parent) {
		this.id = id;
		this.parent = parent;
	}
	
	public int getID() {
		return id;
	}
	
	public Scope getParent() {
		return parent;
	}
}
