package com.dat3m.dartagnan.analysis;

public enum SolverTypes {
	TWO, INCREMENTAL, ASSUME, REFINEMENT;
	
	public static SolverTypes fromString(String s) {
        if(s != null){
            s = s.trim();
            switch(s){
                case "two":
                    return TWO;
                case "incremental":
                    return INCREMENTAL;
                case "assume":
                    return ASSUME;
                case "refinement":
                    return REFINEMENT;
            }
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + s);
	}
	
	public String toString() {
        switch(this) {
            case TWO:
                return "two";
            case INCREMENTAL:
                return "incremental";
            case ASSUME:
                return "assume";
            case REFINEMENT:
                return "refinement";
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + this);
	}
}
