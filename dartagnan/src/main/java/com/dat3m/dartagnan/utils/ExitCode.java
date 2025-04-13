package com.dat3m.dartagnan.utils;

public enum ExitCode {
    // Normal termination
    NORMAL_TERMINATION, BOUNDED_RESULT,
    // Verification errors
    PROGRAM_SPEC_VIOLATION, CAT_SPEC_VIOLATION, TERMINATION_VIOLATION, DATA_RACE_FREEDOM_VIOLATION,
    // Unexpected results
    UNKNOWN_ERROR, TIMEOUT_ELAPSED;

    public int getExitCode() {
        return switch (this) {
            case NORMAL_TERMINATION -> 0;
            case BOUNDED_RESULT -> 1;
            case PROGRAM_SPEC_VIOLATION -> 10;
            case CAT_SPEC_VIOLATION -> 11;
            case TERMINATION_VIOLATION -> 12;
            case DATA_RACE_FREEDOM_VIOLATION -> 13;
            case UNKNOWN_ERROR -> 20;
            case TIMEOUT_ELAPSED -> 21;
        };
    }
}
