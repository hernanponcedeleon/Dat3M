package com.dat3m.dartagnan.verification;

// TODO: Maybe add BOUNDED_PASS and BOUNDED_FAIL:
//  BOUNDED_PASS is for safety props (safe up-to bound, more unrolling could make bug reachable)
//  BOUNDED_FAIL is for reachability props (prop failed up-to bound, more unrolling could make goal reachable)
public enum ResultStatus {
    PASS, FAIL, BOUNDED, UNKNOWN, ERROR, INTERRUPTED;

    public ResultStatus invert() {
        return switch (this) {
            case PASS -> FAIL;
            case FAIL -> PASS;
            default -> this;
        };
    }

    public boolean isBounded() {
        return this == BOUNDED;
    }

}
