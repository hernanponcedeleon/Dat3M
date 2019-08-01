package com.dat3m.dartagnan.parsers.boogie;

public class Scope {

	private int id;
	private Scope parent;
	private boolean endLabel = false;
	
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
	
	public void setEndLabel(boolean value) {
		this.endLabel = value;
	}
	
	public boolean getEndLabel() {
		return endLabel;
	}
}
