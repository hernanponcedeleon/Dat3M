package com.dat3m.dartagnan.verification;

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
