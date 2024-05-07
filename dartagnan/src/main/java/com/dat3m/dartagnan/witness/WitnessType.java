package com.dat3m.dartagnan.witness;

import com.dat3m.dartagnan.configuration.OptionInterface;

public enum WitnessType implements OptionInterface {
    NONE, GRAPHML, GRAPHVIZDOT, GRAPHVIZPNG;

    // Used for options in the console
    @Override
    public String asStringOption() {
        return switch (this) {
            case NONE -> "none";
            case GRAPHML -> "graphml";
            case GRAPHVIZDOT -> "graphviz.dot";
            case GRAPHVIZPNG -> "graphviz.png";
            default -> throw new UnsupportedOperationException("Unrecognized witness type " + this); 
        };
    }

    public static WitnessType getDefault() {
        return NONE;
    }

    public static boolean generateGraphviz(WitnessType type) {
        return type.equals(GRAPHVIZDOT) || type.equals(GRAPHVIZPNG);
    }
}