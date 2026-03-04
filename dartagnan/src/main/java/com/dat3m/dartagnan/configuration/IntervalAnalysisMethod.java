package com.dat3m.dartagnan.configuration;

public enum IntervalAnalysisMethod implements OptionInterface {
    NONE, LOCAL, GLOBAL;

    public static IntervalAnalysisMethod getDefault() {
        return NONE;
    }

}
