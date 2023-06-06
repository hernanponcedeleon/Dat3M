package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

public enum Arch implements OptionInterface {
	C11, ARM8, POWER, PTX, TSO, IMM, LKMM, RISCV;

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
            case PTX:
                return "PTX";
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
		Arch[] order = { C11, ARM8, IMM, LKMM, POWER, PTX, RISCV, TSO };
		// Be sure no element is missing
		assert(Arrays.asList(order).containsAll(Arrays.asList(values())));
		return order;
	}

    // used to check if the coherence is not guaranteed to be total in model
    public static boolean coIsTotal(Arch arch) {
        Arch[] coNotTotal = {PTX};
        return !Arrays.asList(coNotTotal).contains(arch);
    }

    // used to check if supports virtual addressing.
    public static boolean supportsVirtualAddressing(Arch arch) {
        Arch[] supportVirtualAddress = {PTX};
        return Arrays.asList(supportVirtualAddress).contains(arch);
    }

    // Set to false for architectures don't hold local consistency e.g. PTX
    // When location accessed via different proxies but not properly synchronized,
    // they can form intra-thread data races.
    public static boolean archLocallyConsistent(Arch arch, boolean assumeLocalConsistency) {
        Arch[] supportVirtualAddress = {PTX};
        if (Arrays.asList(supportVirtualAddress).contains(arch)) {
            return false;
        } else {
            return assumeLocalConsistency;
        }
    }
}