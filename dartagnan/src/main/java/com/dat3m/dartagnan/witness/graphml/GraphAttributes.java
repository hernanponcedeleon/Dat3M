package com.dat3m.dartagnan.witness.graphml;

public enum GraphAttributes {

	// General attributes
	ARCHITECTURE, CREATIONTIME, PRODUCER, PROGRAMFILE, PROGRAMHASH, SOURCECODELANG, SPECIFICATION, WITNESSTYPE;

	@Override
	public String toString() {
		switch(this) {
		case ARCHITECTURE:
			return "architecture";
		case CREATIONTIME:
			return "creationtime";
		case PRODUCER:
			return "producer";
		case PROGRAMFILE:
			return "programfile";
		case PROGRAMHASH:
			return "programhash";
		case SOURCECODELANG:
			return "sourcecodelang";
		case SPECIFICATION:
			return "specification";
		case WITNESSTYPE:
			return "witness-type";
		}
		throw new UnsupportedOperationException(this + " cannot be converted to String");
	}
}
