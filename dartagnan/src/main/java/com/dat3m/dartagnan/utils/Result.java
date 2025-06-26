package com.dat3m.dartagnan.utils;

//TODO (HP): Can we add some result for "Bounded Safety" and use UNKNOWN for cases where we really have
// no result (e.g. inconclusive Saturation-Refinement)
public enum Result {
	PASS, FAIL, UNKNOWN, ERROR, TIMEDOUT;

	public Result invert() {
        return switch (this) {
            case PASS -> FAIL;
            case FAIL -> PASS;
            default -> this;
        };
    }
}
