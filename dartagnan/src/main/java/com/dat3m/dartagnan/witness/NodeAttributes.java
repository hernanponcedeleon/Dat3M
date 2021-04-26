package com.dat3m.dartagnan.witness;

public enum NodeAttributes {

	ENTRY, VIOLATION;

	@Override
	public String toString() {
		switch(this) {
		case ENTRY:
			return "entry";
		case VIOLATION:
			return "violation";
		default:
			throw new RuntimeException(this + " cannot be converted to String");
		}
	}
}
