package com.dat3m.dartagnan.utils;

//TODO (HP): Can we add some result for "Bounded Safety" and use UNKNOWN for cases where we really have
// no result (e.g. inconclusive Saturation-Refinement)
public enum Result {
	PASS, FAIL, UNKNOWN;

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
