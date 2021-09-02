package com.dat3m.dartagnan.analysis.graphRefinement;

public enum RefinementStatus {
    VERIFIED, REFUTED, INCONCLUSIVE;


    @Override
    public String toString() {
        switch (this) {
            case VERIFIED:
                return "Verified";
            case REFUTED:
                return "Refuted";
            case INCONCLUSIVE:
                return "Inconclusive";
            default:
                throw new UnsupportedOperationException("The enum value " + this.name() + "is not known.");
        }
    }
}
