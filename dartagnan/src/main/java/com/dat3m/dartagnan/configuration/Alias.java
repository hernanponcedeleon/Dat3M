package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

public enum Alias implements OptionInterface {
	// For comparison reasons, we might want to add a NONE method with may = true, must = false
	FIELD_SENSITIVE, FIELD_INSENSITIVE, FULL;

	public static Alias getDefault() {
		return FULL;
	}
	
	// Used to decide the order shown by the selector in the UI
	public static Alias[] orderedValues() {
		Alias[] order = { FIELD_SENSITIVE, FIELD_INSENSITIVE, FULL };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
}