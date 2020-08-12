package com.dat3m.dartagnan.utils;

public enum Result {
	PASS, FAIL, UNKNOWN;

	public static Result fromString(String name) {
		switch (name) {
		case "PASS":
			return PASS;
		case "FAIL":
			return FAIL;
		case "UNKNOWN":
			return UNKNOWN;
		}
        throw new UnsupportedOperationException("Illegal operator in Result");
	}
	
	public Result invert() {
		switch (this) {
		case PASS:
			return FAIL;
		case FAIL:
			return PASS;
		case UNKNOWN:
			return UNKNOWN;
		}
		throw new UnsupportedOperationException("Illegal operator in Result");
	}
}
