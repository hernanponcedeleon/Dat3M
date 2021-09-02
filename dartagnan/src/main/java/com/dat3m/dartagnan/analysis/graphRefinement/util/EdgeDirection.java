package com.dat3m.dartagnan.analysis.graphRefinement.util;

public enum EdgeDirection {
    OUTGOING,
    INGOING;

    public EdgeDirection flip() {
        EdgeDirection dir;
        switch (this) {
            case INGOING:
                dir = OUTGOING;
                break;
            case OUTGOING:
                dir = INGOING;
                break;
            default:
                throw new IllegalStateException(this + " is an unknown enum member.");
        }
        return dir;
    }

}
