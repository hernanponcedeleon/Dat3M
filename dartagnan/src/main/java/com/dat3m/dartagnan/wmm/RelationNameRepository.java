package com.dat3m.dartagnan.wmm;

import com.google.common.collect.ImmutableSet;

import java.util.Arrays;

public class RelationNameRepository {

    public static final String PO = "po";
    public static final String LOC = "loc";
    public static final String ID = "id";
    public static final String INT = "int";
    public static final String EXT = "ext";
    public static final String CO = "co";
    public static final String RF = "rf";
    public static final String RMW = "rmw";
    public static final String CRIT = "rcu-rscs";
    public static final String IDD = "idd";
    public static final String ADDRDIRECT = "addrDirect";
    public static final String CTRLDIRECT = "ctrlDirect";
    public static final String EMPTY = "0";
    public static final String RFINV = "rf^-1";
    public static final String FR = "fr";
    public static final String MM = "(M*M)";
    public static final String MV = "(M*V)";
    public static final String IDDTRANS = "idd^+";
    public static final String DATA = "data";
    public static final String ADDR = "addr";
    public static final String CTRL = "ctrl";
    public static final String POLOC = "po-loc";
    public static final String RFE = "rfe";
    public static final String RFI = "rfi";
    public static final String COE = "coe";
    public static final String COI = "coi";
    public static final String FRE = "fre";
    public static final String FRI = "fri";
    public static final String MFENCE = "mfence";
    public static final String ISH = "ish";
    public static final String ISB = "isb";
    public static final String SYNC = "sync";
    public static final String ISYNC = "isync";
    public static final String LWSYNC = "lwsync";
    public static final String CTRLISYNC = "ctrlisync";
    public static final String CTRLISB = "ctrlisb";
    public static final String CASDEP = "casdep";
    public static final String SR = "sr";
    public static final String SCTA = "scta"; // same-cta, the same as same_block_r in alloy
    public static final String SSG = "ssg";
    public static final String SWG = "swg";
    public static final String SQF = "sqf";
    public static final String SSW = "ssw";
    public static final String SYNC_BARRIER = "sync_barrier";
    public static final String SYNC_FENCE = "sync_fence";
    public static final String SYNCBAR = "syncbar";
    public static final String VLOC = "vloc";

    public static final ImmutableSet<String> RELATION_NAMES;

    static {
        // CARE: Using reflection inside the class initializer is dangerous,
        // but it works here because all constants get initialized before the initializer runs.
        RELATION_NAMES = Arrays.stream(RelationNameRepository.class.getDeclaredFields())
                .filter(f -> f.getType().equals(String.class))
                .map(f -> {
                    try {
                        return (String) f.get(null);
                    } catch (IllegalAccessException e) {
                        throw new RuntimeException(e);
                    }
                }).collect(ImmutableSet.toImmutableSet());
    }

    public static boolean contains(String name) {
        return RELATION_NAMES.contains(name);
    }

}
