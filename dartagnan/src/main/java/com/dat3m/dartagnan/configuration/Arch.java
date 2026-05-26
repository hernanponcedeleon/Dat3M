package com.dat3m.dartagnan.configuration;

import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.definition.*;

import java.util.Arrays;

public enum Arch implements OptionInterface {
    C11, ARM7, ARM8, POWER, PTX, TSO, IMM, LKMM, RISCV, VULKAN, OPENCL;

    public static boolean forcePartialCo = false;

    // Used to display in UI
    @Override
    public String toString() {
        return switch (this) {
            case C11 -> "C11";
            case ARM7 -> "ARM7";
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
        Arch[] order = { C11, ARM7, ARM8, IMM, LKMM, OPENCL, POWER, PTX, RISCV, TSO, VULKAN };
        // Be sure no element is missing
        assert (Arrays.asList(order).containsAll(Arrays.asList(values())));
        return order;
    }

    // used to check if the coherence is not guaranteed to be total in model
    public static boolean coIsTotal(Arch arch) {
        Arch[] coNotTotal = {PTX};
        if (!forcePartialCo) {
            return !Arrays.asList(coNotTotal).contains(arch);
        }
        return false;
    }

    // used to check if supports virtual addressing.
    public static boolean supportsVirtualAddressing(Arch arch) {
        Arch[] supportVirtualAddress = {PTX, VULKAN};
        return Arrays.asList(supportVirtualAddress).contains(arch);
    }

    public static void addVulkanPartialCoConstraints(Wmm wmm) {
        Relation w = wmm.getRelation("W");
        Relation iw = wmm.getRelation("IW");
        Relation wNotIw = wmm.addDefinition(new Difference(wmm.newRelation(Relation.Arity.UNARY), w, iw));
        Relation ww = wmm.addDefinition(new CartesianProduct(wmm.newRelation(), w, w));

        Relation wwLocord = wmm.addDefinition(new Intersection(wmm.newRelation(), ww, wmm.getRelation("locord")));
        Relation cst1 = wmm.addDefinition(new Difference(wmm.newRelation("cst1"), wwLocord, wmm.getRelation("co")));

        Relation wwMutordatom = wmm.addDefinition(new Intersection(wmm.newRelation(), ww, wmm.getRelation("mutordatom")));
        Relation coInv = wmm.addDefinition(new Inverse(wmm.newRelation(), wmm.getRelation("co")));
        Relation coOrInv = wmm.addDefinition(new Union(wmm.newRelation(), wmm.getRelation("co"), coInv));
        Relation cst2 = wmm.addDefinition(new Difference(wmm.newRelation("cst2"), wwMutordatom, coOrInv));

        Relation iwToWNotIw = wmm.addDefinition(new CartesianProduct(wmm.newRelation(), iw, wNotIw));
        Relation locAndVloc = wmm.addDefinition(new Intersection(wmm.newRelation(), wmm.getRelation("loc"), wmm.getRelation("vloc")));
        Relation vlocIwToWNotIw = wmm.addDefinition(new Intersection(wmm.newRelation(), iwToWNotIw, locAndVloc));
        Relation cst3 = wmm.addDefinition(new Difference(wmm.newRelation("cst3"), vlocIwToWNotIw, wmm.getRelation("co")));

        wmm.addConstraint(new Emptiness(cst1, false, false));
        wmm.addConstraint(new Emptiness(cst2, false, false));
        wmm.addConstraint(new Emptiness(cst3, false, false));
    }
}