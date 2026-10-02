package com.dat3m.dartagnan.verification;

//TODO (HP): Can we add some result for "Bounded Safety" and use UNKNOWN for cases where we really have
// no result (e.g. inconclusive Saturation-Refinement)
public enum VerificationStatus {
    PASS, FAIL, UNKNOWN;

    public VerificationStatus invert() {
        return switch (this) {
            case PASS -> FAIL;
            case FAIL -> PASS;
            default -> this;
        };
    }
}
