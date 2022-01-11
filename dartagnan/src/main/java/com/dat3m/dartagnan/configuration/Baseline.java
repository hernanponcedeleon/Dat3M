package com.dat3m.dartagnan.configuration;

public enum Baseline implements OptionInterface {

	NONE, UNIPROC, NO_OOTA, ATOMIC_RMW;
	
	// Used for options in the console
	@Override
	public String asStringOption() {
		return toString().toLowerCase();
	}
}