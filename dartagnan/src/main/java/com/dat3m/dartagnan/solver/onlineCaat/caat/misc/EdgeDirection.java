package com.dat3m.dartagnan.solver.onlineCaat.caat.misc;

public enum EdgeDirection {
    OUTGOING,
    INGOING;

    public EdgeDirection flip() {
        switch (this) {
            case INGOING:
                return OUTGOING;
            case OUTGOING:
                return INGOING;
            default:
                throw new IllegalStateException(this + " is an unknown enum member.");
        }
    }

}
