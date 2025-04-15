package com.dat3m.dartagnan.utils;

public enum ExitCode {
    // Normal termination
    NORMAL_TERMINATION, BOUNDED_RESULT,
    // Verification errors
    PROGRAM_SPEC_VIOLATION, CAT_SPEC_VIOLATION, TERMINATION_VIOLATION, DATA_RACE_FREEDOM_VIOLATION,
    // Witness validation errors
    WITNESS_NOT_VALIDATED, WRONG_WITNESS_FILE,
    // Unexpected results
    UNKNOWN_ERROR, TIMEOUT_ELAPSED;

    public int asInt() {
        return switch (this) {
            case NORMAL_TERMINATION -> 0;
            case BOUNDED_RESULT -> 1;
            case PROGRAM_SPEC_VIOLATION -> 10;
            case CAT_SPEC_VIOLATION -> 11;
            case TERMINATION_VIOLATION -> 12;
            case DATA_RACE_FREEDOM_VIOLATION -> 13;
            case WITNESS_NOT_VALIDATED -> 20;
            case WRONG_WITNESS_FILE -> 21;
            case UNKNOWN_ERROR -> 30;
            case TIMEOUT_ELAPSED -> 31;
        };
    }
}
