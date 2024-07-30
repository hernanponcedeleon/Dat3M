package com.dat3m.dartagnan.configuration;

public enum ProgressModel {
    FAIR, // All threads are fairly scheduled
    HSA, // Lowest id thread gets fairly scheduled.
    OBE, // Threads that made at least one step get fairly scheduled.
    UNFAIR; // No fair scheduling

    public static ProgressModel getDefault() { return FAIR; }
}
