package com.dat3m.dartagnan.witness;

public enum EdgeAttributes {

	CREATETHREAD, THREADID, ENTERFUNCTION, STARTLINE, EVENTID, HBPOS;

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
			return "eventId";
		case HBPOS:
			return "hbPos";
		default:
			throw new RuntimeException(this + " cannot be converted to String");
		}
	}
}
