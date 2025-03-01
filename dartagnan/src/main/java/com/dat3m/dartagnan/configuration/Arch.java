package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

public enum Arch implements OptionInterface {
    C11, ARM8, POWER, PTX, TSO, IMM, LKMM, RISCV, VULKAN, OPENCL;

    // Used to display in UI
    @Override
    public String toString() {
        return switch (this) {
            case C11 -> "C11";
            case ARM8 -> "ARM8";
            case POWER -> "Power";
            case PTX -> "PTX";
            case TSO -> "TSO";
            case IMM -> "IMM";
            case LKMM -> "LKMM";
            case RISCV -> "RISCV";
            case VULKAN -> "VULKAN";
            case OPENCL -> "OpenCL";
        };
    }

    public static Arch getDefault() {
        return C11;
    }

    // Used to decide the order shown by the selector in the UI
    public static Arch[] orderedValues() {
        Arch[] order = { C11, ARM8, IMM, LKMM, OPENCL, POWER, PTX, RISCV, TSO, VULKAN };
        // Be sure no element is missing
        assert (Arrays.asList(order).containsAll(Arrays.asList(values())));
        return order;
    }

    // used to check if the coherence is not guaranteed to be total in model
    public static boolean coIsTotal(Arch arch) {
        Arch[] coNotTotal = {PTX};
        return !Arrays.asList(coNotTotal).contains(arch);
    }

    // used to check if supports virtual addressing.
    public static boolean supportsVirtualAddressing(Arch arch) {
        Arch[] supportVirtualAddress = {PTX, VULKAN};
        return Arrays.asList(supportVirtualAddress).contains(arch);
    }
}