package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.configuration.OptionInterface;

public enum WitnessType implements OptionInterface {
    NONE, GRAPHML, DOT, PNG;

    public static WitnessType getDefault() {
        return NONE;
    }

    public boolean generateGraphviz() {
        return this.equals(DOT) || this.equals(PNG);
    }

    public boolean convertToPng() {
        return this.equals(PNG);
    }

}