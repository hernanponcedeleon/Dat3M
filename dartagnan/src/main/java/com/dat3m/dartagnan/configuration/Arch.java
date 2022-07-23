package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

import com.dat3m.dartagnan.configuration.OptionInterface;

public enum Arch implements OptionInterface {
	C11, ARM8, POWER, TSO, IMM, LKMM, RISCV;

	// Used to display in UI
    @Override
    public String toString() {
        switch(this){
            case C11:
                return "C11";
            case ARM8:
                return "ARM8";
            case POWER:
                return "Power";
            case TSO:
                return "TSO";
            case IMM:
                return "IMM";
            case LKMM:
                return "LKMM";
            case RISCV:
                return "RISCV";
        }
        throw new UnsupportedOperationException("Unrecognized architecture " + this);
    }

	public static Arch getDefault() {
		return C11;
	}
	
	// Used to decide the order shown by the selector in the UI
	public static Arch[] orderedValues() {
		Arch[] order = { C11, ARM8, IMM, LKMM, POWER, RISCV, TSO };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}
}