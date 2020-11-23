package com.dat3m.dartagnan.analysis;

public enum AnalysisTypes {
	REACHABILITY, RACES, TERMINATION;
	
	public static AnalysisTypes fromString(String s) {
        if(s != null){
            s = s.trim();
            switch(s){
                case "reachability":
                    return REACHABILITY;
                case "races":
                    return RACES;
                case "termination":
                    return TERMINATION;
            }
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + s);
	}
}
