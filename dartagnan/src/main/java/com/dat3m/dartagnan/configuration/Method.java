package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

public enum Method implements OptionInterface {
	ASSUME, CAAT;
	
	// Used for options in the console
	@Override
	public String asStringOption() {
        switch(this) {
        	case ASSUME:
        		return "assume";
			case CAAT:
				return "caat";
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + this);
	}

	// Used to display in UI
	@Override
	public String toString() {
        switch(this) {
			case ASSUME:
            	return "Solver with Assumption";
            case CAAT:
            	return "CAAT Solver";
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + this);
	}

	public static Method getDefault() {
		return CAAT;
	}
	
	// Used to decide the order shown by the selector in the UI
	public static Method[] orderedValues() {
		Method[] order = { ASSUME, CAAT};
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
}