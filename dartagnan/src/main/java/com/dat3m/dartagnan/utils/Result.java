package com.dat3m.dartagnan.utils;

public enum Result {
	PASS, FAIL, UNKNOWN, BPASS, BFAIL;

	public static Result fromString(String name) {
		switch (name) {
		case "PASS":
			return PASS;
		case "BPASS":
			return BPASS;
		case "FAIL":
			return FAIL;
		case "BFAIL":
			return BFAIL;
		default:
			return UNKNOWN;
		}
	}
	
	public Result invert() {
		switch (this) {
		case PASS:
			return FAIL;
		case BPASS:
			return BFAIL;
		case FAIL:
			return PASS;
		case BFAIL:
			return BPASS;
		default:
			return UNKNOWN;
		}
	}
}
