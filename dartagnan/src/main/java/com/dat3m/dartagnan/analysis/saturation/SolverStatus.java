package com.dat3m.dartagnan.analysis.saturation;

public enum SolverStatus {
    CONSISTENT, INCONSISTENT, INCONCLUSIVE;


    @Override
    public String toString() {
        switch (this) {
            case CONSISTENT:
                return "Consistent";
            case INCONSISTENT:
                return "Inconsistent";
            case INCONCLUSIVE:
                return "Inconclusive";
            default:
                throw new UnsupportedOperationException("The enum value " + this.name() + "is not known.");
        }
    }
}
