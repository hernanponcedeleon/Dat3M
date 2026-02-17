package com.dat3m.dartagnan.configuration;

public enum IntervalAnalysisOptions implements OptionInterface {
    NONE, LOCAL, GLOBAL;

    public static IntervalAnalysisOptions getDefault() {
        return NONE;
    }

}
