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
    public static final String EMPTY = "0";
    public static final String DATA = "data";
    public static final String ADDR = "addr";
    public static final String CTRL = "ctrl";
    public static final String CASDEP = "casdep";
    public static final String SR = "sr";
    public static final String SCTA = "scta"; // same-cta, the same as same_block_r in alloy
    public static final String SSG = "ssg";
    public static final String SWG = "swg";
    public static final String SQF = "sqf";
    public static final String SDV = "sdv";
    public static final String SSW = "ssw";
    public static final String SYNC_FENCE = "sync_fence";
    public static final String SYNCBAR = "syncbar";
    public static final String VLOC = "vloc";
    // private relations, not to be exposed in cat
    public static final String IDD = "__idd";
    public static final String ADDRDIRECT = "__addrDirect";
    public static final String CTRLDIRECT = "__ctrlDirect";
    public static final String IDDTRANS = "__iddTrans";

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
