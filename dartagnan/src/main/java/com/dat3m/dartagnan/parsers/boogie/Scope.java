package com.dat3m.dartagnan.parsers.boogie;

public class Scope {

	private int id;
	private int threadId;
	private Scope parent;
	private boolean endLabel = false;
	
	public Scope(int id, int threadId, Scope parent) {
		this.id = id;
		this.threadId = threadId;
		this.parent = parent;
	}
	
	public int getID() {
		return id;
	}
	
	public int getThreadId() {
		return threadId;
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
