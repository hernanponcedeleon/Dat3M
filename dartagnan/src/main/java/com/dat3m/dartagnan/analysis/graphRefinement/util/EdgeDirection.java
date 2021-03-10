package com.dat3m.dartagnan.analysis.graphRefinement.util;

public enum EdgeDirection {
    Outgoing,
    Ingoing;

    public EdgeDirection flip() {
        EdgeDirection dir;
        switch (this) {
            case Ingoing:
                dir = Outgoing;
                break;
            case Outgoing:
                dir = Ingoing;
                break;
            default:
                throw new IllegalStateException();
        }
        return dir;
    }

}
