package com.dat3m.dartagnan.configuration;

public interface OptionInterface {
	
	// Used for options in the console
	public String asStringOption();

	// Used to display in UI
	@Override
	public String toString();

	public static OptionInterface getDefault() {
        throw new UnsupportedOperationException("getDefault() not implemented");
	}
	
	// Used to decide the order shown by the selector in the UI
	public static OptionInterface[] orderedValues() {
		throw new UnsupportedOperationException("orderedValues() not implemented");
	}
}