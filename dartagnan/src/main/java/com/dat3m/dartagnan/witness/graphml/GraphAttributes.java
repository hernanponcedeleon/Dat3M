package com.dat3m.dartagnan.witness.graphml;

public enum GraphAttributes {

	// General attributes
	ARCHITECTURE, CREATIONTIME, PRODUCER, PROGRAMFILE, PROGRAMHASH, SOURCECODELANG, SPECIFICATION, WITNESSTYPE,
	// Dartagnan specific attributes
	UNROLLBOUND;

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
		case UNROLLBOUND:
			return "unroll-bound";
		case WITNESSTYPE:
			return "witness-type";
		}
		throw new UnsupportedOperationException(this + " cannot be converted to String");
	}
}
