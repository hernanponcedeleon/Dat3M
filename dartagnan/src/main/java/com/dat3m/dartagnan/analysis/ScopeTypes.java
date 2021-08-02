package com.dat3m.dartagnan.analysis;

public enum ScopeTypes {
	TWO, INCREMENTAL, ASSUME;
	
	public static ScopeTypes fromString(String s) {
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
	
	public String toString() {
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
}
