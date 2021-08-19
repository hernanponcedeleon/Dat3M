package com.dat3m.dartagnan.analysis;

public enum Method {
	ASSUME, INCREMENTAL, TWO;
	
	public static Method get(String s) {
        if(s != null){
            s = s.trim();
            switch(s){
                case "two":
                    return TWO;
                case "incremental":
                    return INCREMENTAL;
                case "assume":
                    return ASSUME;
            }
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + s);
	}

	// Used for options in the console
	public String asStringOption() {
        switch(this) {
        	case TWO:
        		return "two";
        	case INCREMENTAL:
        		return "incremental";
        	case ASSUME:
        		return "assume";
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
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + this);
	}

	public static Method getDefault() {
		return INCREMENTAL;
	}
}
