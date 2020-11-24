package com.dat3m.dartagnan.program.arch.linux.utils;

public class Mo {

    public static final String MB       = "Mb";
    public static final String RELAXED  = "Relaxed";
    public static final String RELEASE  = "Release";
    public static final String ACQUIRE  = "Acquire";

    public static String loadMO(String mo){
        return mo.equals(ACQUIRE) ? ACQUIRE : RELAXED;
    }

    public static String storeMO(String mo){
        return mo.equals(RELEASE) ? RELEASE : RELAXED;
    }

    public static String toText(String mo){
        switch (mo){
            case RELAXED:
                return "_relaxed";
            case ACQUIRE:
                return "_acquire";
            case RELEASE:
                return "_release";
            case MB:
                return "";
        }
        throw new IllegalArgumentException("Unrecognised memory order " + mo);
    }
}
