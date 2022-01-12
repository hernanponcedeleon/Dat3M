package com.dat3m.dartagnan.program.event.lang.linux.utils;

public class Tag extends com.dat3m.dartagnan.program.event.Tag {

    public static final String NORETURN     = "Noreturn";
    public static final String RCU_SYNC     = "Sync-rcu";
    public static final String RCU_LOCK     = "Rcu-lock";
    public static final String RCU_UNLOCK   = "Rcu-unlock";
    public static final String MB       = "Mb";
    public static final String RELAXED = "Relaxed";
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
