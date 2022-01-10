package com.dat3m.dartagnan.configuration;

public interface OptionInterface {
	
	// Used for options in the console
	public String asStringOption();

	// Used to display in UI
	@Override
	public String toString();

}