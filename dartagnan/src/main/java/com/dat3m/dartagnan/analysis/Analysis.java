package com.dat3m.dartagnan.analysis;

public enum Analysis {
	REACHABILITY, RACES;
	
	public static Analysis get(String analysis) {
        if(analysis != null){
        	analysis = analysis.trim();
            switch(analysis){
            	case "reachability":
            		return REACHABILITY;
            	case "races":
            		return RACES;
            }
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + analysis);
    }

	// Used for options in the console
	public String asStringOption() {
        switch(this){
        	case REACHABILITY:
        		return "reachability";
        	case RACES:
        		return "races";
        }
        throw new UnsupportedOperationException("Unrecognized analysis " + this);
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
        throw new UnsupportedOperationException("Unrecognized analysis " + this);
    }

	public static Analysis getDefault() {
		return REACHABILITY;
	}
}
