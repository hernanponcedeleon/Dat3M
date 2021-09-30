package com.dat3m.dartagnan.witness;

public enum GraphAttributes {

	// General attributes
	ARCHITECTURE, CREATIONTIME, PRODUCER, PROGRAMFILE, PROGRAMHASH, SOURCECODELANG, SPECIFICATION, WITNESSTYPE,
	// Dartagnan specific attributes
	UNROLLBOUND, EVENTID, LOADEDVALUE, STOREDVALUE;

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
		case EVENTID:
			return "event-id";
		case LOADEDVALUE:
			return "loaded-value";
		case STOREDVALUE:
			return "stored-value";
		}
		throw new RuntimeException(this + " cannot be converted to String");
	}
}
