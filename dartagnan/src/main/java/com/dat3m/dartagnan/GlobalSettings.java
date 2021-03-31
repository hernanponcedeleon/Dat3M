package com.dat3m.dartagnan;

public class GlobalSettings {
    // === Parsing ===
    public static final boolean ATOMIC_AS_LOCK = false;

    // === WMM Assumptions ===
    public static final boolean ASSUME_LOCAL_CONSISTENCY = true;

    // === Encoding ===
    public static final boolean MERGE_CF_VARS = true;

    // === BranchEquivalence ===
    public static final boolean MERGE_BRANCHES = true;
    public static final boolean ALWAYS_SPLIT_ON_JUMP = false;

    // === Static analysis ===
    public static final boolean PERFORM_DEAD_CODE_ELIMINATION = true;

    // === Recursion depth ===
    public static final int MAX_RECURSION_DEPTH = 200;

    private GlobalSettings() {}
}
