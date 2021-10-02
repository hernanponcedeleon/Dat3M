package com.dat3m.dartagnan.utils;

public class BitFlags {
    private BitFlags() { }

    public static boolean isSet(long bitSet, long flags) {
        return (bitSet & flags) == flags;
    }
}
