package com.dat3m.dartagnan.verification.solving;

import java.util.Arrays;

public enum Property {
	REACHABILITY, RACES;
	
	// Used for options in the console
	public String asStringOption() {
        switch(this){
        	case REACHABILITY:
        		return "reachability";
        	case RACES:
        		return "races";
        }
        throw new UnsupportedOperationException("Unrecognized property: " + this);
	}

	// Used to display in UI
    @Override
    public String toString() {
        switch(this){
        	case REACHABILITY:
        		return "Reachability";
        	case RACES:
        		return "Races";
        }
        throw new UnsupportedOperationException("Unrecognized property: " + this);
    }

	public static Property getDefault() {
		return REACHABILITY;
	}

	// Used to decide the order shown by the selector in the UI
	public static Property[] orderedValues() {
		Property[] order = { REACHABILITY, RACES };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
}