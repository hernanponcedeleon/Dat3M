package com.dat3m.dartagnan.configuration;

import java.util.Arrays;

public enum RelationAnalysisMethod implements OptionInterface {
    NONE, NATIVE, LAZY;

    public static RelationAnalysisMethod getDefault() {
        return NATIVE;
    }

    // Used to decide the order shown by the selector in the UI
    public static RelationAnalysisMethod[] orderedValues() {
        RelationAnalysisMethod[] order = {NONE, NATIVE, LAZY};
        // Be sure no element is missing
        assert (Arrays.asList(order).containsAll(Arrays.asList(values())));
        return order;
    }
}
