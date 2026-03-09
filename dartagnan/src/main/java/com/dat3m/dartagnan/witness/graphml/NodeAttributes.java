package com.dat3m.dartagnan.witness.graphml;

public enum NodeAttributes {

    ENTRY, VIOLATION;

    @Override
    public String toString() {
        return switch (this) {
            case ENTRY -> "entry";
            case VIOLATION -> "violation";
        };
    }
}
