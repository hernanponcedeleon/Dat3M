package com.dat3m.dartagnan.solver.caat.misc;

public enum EdgeDirection {
    OUTGOING,
    INGOING;

    public EdgeDirection flip() {
        return switch (this) {
            case INGOING -> OUTGOING;
            case OUTGOING -> INGOING;
        };
    }

}
