package com.dat3m.dartagnan.witness;

public enum GraphAttributes {

	PRODUCER;

	@Override
	public String toString() {
		switch(this) {
		case PRODUCER:
			return "PRODUCER";
		default:
			throw new RuntimeException(this + " cannot be converted to String");
		}
	}
}
