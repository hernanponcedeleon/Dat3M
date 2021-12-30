package com.dat3m.dartagnan.wmm.utils;

import java.util.Arrays;

public enum Arch {
	NONE, ARM8, POWER, TSO;

    public static Arch get(String arch){
        if(arch != null){
            arch = arch.trim();
            switch(arch){
                case "none":
                    return NONE;
                case "arm8":
                    return ARM8;
                case "power":
                    return POWER;
                case "tso":
                    return TSO;
            }
        }
        throw new UnsupportedOperationException("Unrecognized architecture " + arch);
    }

	// Used for options in the console
	public String asStringOption() {
        switch(this){
        	case NONE:
        		return "none";
        	case ARM8:
        		return "arm8";
        	case POWER:
        		return "power";
        	case TSO:
        		return "tso";
        }
        throw new UnsupportedOperationException("Unrecognized architecture " + this);
	}

	// Used to display in UI
    @Override
    public String toString() {
        switch(this){
            case NONE:
                return "None";
            case ARM8:
                return "ARM8";
            case POWER:
                return "Power";
            case TSO:
                return "TSO";
        }
        throw new UnsupportedOperationException("Unrecognized architecture " + this);
    }

	public static Arch getDefault() {
		return NONE;
	}
	
	// Used to decide the order shown by the selector in the UI
	public static Arch[] orderedValues() {
		Arch[] order = { NONE, ARM8, POWER, TSO };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
}
