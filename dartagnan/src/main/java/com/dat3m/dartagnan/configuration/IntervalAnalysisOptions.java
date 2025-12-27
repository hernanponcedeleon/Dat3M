package com.dat3m.dartagnan.configuration;

public enum IntervalAnalysisOptions implements OptionInterface{
    NAIVE,LOCAL,GLOBAL;

    public static IntervalAnalysisOptions getDefault() {
        return NAIVE;
    }

}
