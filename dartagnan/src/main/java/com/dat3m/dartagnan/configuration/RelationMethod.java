package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

public enum RelationMethod implements OptionInterface {
	NONE, NATIVE;

	public static RelationMethod getDefault() {
		return NATIVE;
	}
	
	// Used to decide the order shown by the selector in the UI
	public static RelationMethod[] orderedValues() {
		RelationMethod[] order = { NONE, NATIVE };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
}
