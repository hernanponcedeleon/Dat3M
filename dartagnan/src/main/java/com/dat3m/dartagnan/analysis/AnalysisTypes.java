package com.dat3m.dartagnan.analysis;

public enum AnalysisTypes {
	REACHABILITY, RACES;
	
	public static AnalysisTypes fromString(String s) {
        if(s != null){
            s = s.trim();
            switch(s){
                case "reachability":
                    return REACHABILITY;
                case "races":
                    return RACES;
            }
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + s);
	}
	
	public String toString() {
        switch(this) {
            case REACHABILITY:
                return "reachability";
            case RACES:
                return "races";
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + this);
	}
}
