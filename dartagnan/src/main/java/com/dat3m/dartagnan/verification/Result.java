package com.dat3m.dartagnan.verification;

public enum Result {
    PASS, FAIL, BOUNDED, UNKNOWN, ERROR, INTERRUPTED;

    public Result invert() {
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
