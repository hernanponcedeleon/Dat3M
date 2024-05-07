package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.configuration.OptionInterface;

public enum WitnessType implements OptionInterface {
    NONE, GRAPHML, DOT, PNG;

    public static WitnessType getDefault() {
        return NONE;
    }

    public static boolean generateGraphviz(WitnessType type) {
        return type.equals(DOT) || type.equals(PNG);
    }
}