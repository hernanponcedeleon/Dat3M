package com.dat3m.dartagnan.wmm.utils;

import com.google.common.collect.ImmutableSet;

public class Arch {

    public static final ImmutableSet<String> targets = ImmutableSet.of("alpha", "arm", "power", "pso", "rmo", "tso", "sc");

    // Architectures where ctrl = ctrl ; po
    private static final ImmutableSet<String> ctrlPo = ImmutableSet.of("alpha", "arm", "power", "rmo");


    public static boolean encodeCtrlPo(String arch){
        if(ctrlPo.contains(arch)){
            return true;
        }

        if(targets.contains(arch)){
            return false;
        }

        throw new RuntimeException("Unrecognised architecture " + arch);
    }
}
