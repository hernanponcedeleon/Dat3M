package com.dat3m.dartagnan.witness;

public enum GraphAttributes {

	ARCHITECTURE, CREATIONTIME, PRODUCER, PROGRAMFILE, PROGRAMHASH, SOURCECODELANG, SPECIFICATION, UNROLLBOUND, WITNESSTYPE;

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
		default:
			throw new RuntimeException(this + " cannot be converted to String");
		}
	}
}
