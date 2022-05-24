package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

import com.dat3m.dartagnan.configuration.OptionInterface;

public enum Arch implements OptionInterface {
	NONE, ARM8, POWER, TSO, IMM;

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
            case IMM:
                return "IMM";
        }
        throw new UnsupportedOperationException("Unrecognized architecture " + this);
    }

	public static Arch getDefault() {
		return NONE;
	}
	
	// Used to decide the order shown by the selector in the UI
	public static Arch[] orderedValues() {
		Arch[] order = { NONE, ARM8, IMM, POWER, TSO };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
}