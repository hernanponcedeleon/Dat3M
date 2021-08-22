package com.dat3m.dartagnan.wmm.utils.alias;

import java.util.Arrays;

public enum Alias {
    CFIS, // Content flow insensitive (Andersen)
    CFS,  // Content flow sensitive
    NONE;

    public static Alias get(String alias){
        if(alias != null){
            alias = alias.trim();
            switch(alias){
                case "none":
                    return NONE;
                case "andersen":
                    return CFIS;
                case "cfs":
                    return CFS;
            }
        }
        throw new UnsupportedOperationException("Unrecognized alias " + alias);
    }

	// Used for options in the console
	public String asStringOption() {
        switch(this){
        	case NONE:
        		return "none";
        	case CFIS:
        		return "andersen";
        	case CFS:
        		return "cfs";
        }
        throw new UnsupportedOperationException("Unrecognized alias " + this);
	}

	// Used to display in UI
    @Override
    public String toString() {
        switch(this){
            case NONE:
                return "None";
            case CFIS:
                return "Andersen";
            case CFS:
                return "CFS";
        }
        throw new UnsupportedOperationException("Unrecognized alias " + this);
    }

	public static Alias getDefault() {
		return CFIS;
	}
	
	// Used to decide the order shown by the selector in the UI
	public static Alias[] orderedValues() {
		Alias[] order = { NONE, CFIS, CFS };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(Alias.values())));
		return order;
	}
}
