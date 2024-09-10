package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

public enum ProgressModel {
    FAIR, // All threads are fairly scheduled
    HSA, // Lowest id thread gets fairly scheduled.
    OBE, // Threads that made at least one step get fairly scheduled.
    UNFAIR; // No fair scheduling

    public static ProgressModel getDefault() { return FAIR; }

    // Used to decide the order shown by the selector in the UI
	public static ProgressModel[] orderedValues() {
		ProgressModel[] order = { FAIR, HSA, OBE, UNFAIR };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
}
