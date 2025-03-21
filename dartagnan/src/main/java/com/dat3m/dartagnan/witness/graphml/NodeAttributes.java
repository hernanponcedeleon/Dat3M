package com.dat3m.dartagnan.witness.graphml;

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
			throw new UnsupportedOperationException(this + " cannot be converted to String");
		}
	}
}
