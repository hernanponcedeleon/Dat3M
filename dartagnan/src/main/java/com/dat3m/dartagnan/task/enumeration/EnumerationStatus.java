package com.dat3m.dartagnan.task.enumeration;

public enum EnumerationStatus {
    COMPLETE,    // All final states have been enumerated
    INCOMPLETE,  // Not all final states have been enumerated due to incomplete unrolling
    LIMITED;     // Not all final states have been enumerated due to limit of NUM_MAX_STATES reached
}
