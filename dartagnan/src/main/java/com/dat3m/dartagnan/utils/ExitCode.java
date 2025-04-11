package com.dat3m.dartagnan.utils;

public enum ExitCode {
    // Normal termination
    NORMAL_TERMINATION,
    // Unexpected result
    UNKNOWN_ERROR, TIMEOUT_ELAPSED, BOUNDED_RESULT,
    // Verification error
	PROGRAM_SPEC_VIOLATION, CAT_SPEC_VIOLATION, TERMINATION_VIOLATION, DATA_RACE_FREEDOM_VIOLATION;

    public int getExitCode() {
        return switch (this) {
            case NORMAL_TERMINATION -> 0;
            case UNKNOWN_ERROR -> 1;
            case TIMEOUT_ELAPSED -> 2;
            case BOUNDED_RESULT -> 3;
            case PROGRAM_SPEC_VIOLATION -> 4;
            case CAT_SPEC_VIOLATION -> 5;
            case TERMINATION_VIOLATION -> 6;
            case DATA_RACE_FREEDOM_VIOLATION -> 7;
        };
    }
}
