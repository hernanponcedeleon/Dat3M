package com.dat3m.dartagnan.analysis;

import java.util.Arrays;

public enum Method {
	ASSUME, INCREMENTAL, TWO, CAAT;
	
	// Used for options in the console
	public String asStringOption() {
        switch(this) {
        	case TWO:
        		return "two";
        	case INCREMENTAL:
        		return "incremental";
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
			case TWO:
				return "Two Solvers";
			case INCREMENTAL:
				return "Incremental Solver";
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
		Method[] order = { INCREMENTAL, ASSUME, TWO, CAAT};
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
}