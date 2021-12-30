package com.dat3m.dartagnan.witness;

public enum EdgeAttributes {

	CREATETHREAD, THREADID, ENTERFUNCTION, STARTLINE,
	// Dartagnan specific attributes
	EVENTID, LOADEDVALUE, STOREDVALUE;

	@Override
	public String toString() {
		switch(this) {
		case CREATETHREAD:
			return "createThread";
		case THREADID:
			return "threadId";
		case ENTERFUNCTION:
			return "enterFunction";
		case STARTLINE:
			return "startline";
		case EVENTID:
			return "event-id";
		case LOADEDVALUE:
			return "loaded-value";
		case STOREDVALUE:
			return "stored-value";
		default:
			throw new UnsupportedOperationException(this + " cannot be converted to String");
		}
	}
}
