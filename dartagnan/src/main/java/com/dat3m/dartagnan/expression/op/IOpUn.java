package com.dat3m.dartagnan.expression.op;

public enum IOpUn {
    MINUS,
    SIGNED_CAST,
    UNSIGNED_CAST,
    CTLZ;

    @Override
    public String toString() {
        return switch (this) {
            case CTLZ -> "ctlz ";
            case MINUS -> "-";
            case SIGNED_CAST -> "scast ";
            case UNSIGNED_CAST -> "ucast ";
        };
    }
}
