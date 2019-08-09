package com.dat3m.dartagnan.parsers.boogie;

public class Scope {

	private int id;
	private Scope parent;
	
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
