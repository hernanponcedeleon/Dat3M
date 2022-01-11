package com.dat3m.dartagnan.configuration;

import com.dat3m.dartagnan.configuration.OptionInterface;

public enum Baseline implements OptionInterface {
	
	NONE, UNIPROC, NO_OOTA, ATOMIC_RMW;

	// Used for options in the console
	public String asStringOption() {
		return toString().toLowerCase();
	}
}