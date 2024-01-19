package com.dat3m.dartagnan.expression.op;

public enum IntUnaryOp {
    CAST_SIGNED,
    CAST_UNSIGNED,
    CTLZ,
    MINUS;

    @Override
    public String toString() {
        return switch (this) {
            case CAST_SIGNED -> "signed cast";
            case CAST_UNSIGNED -> "unsigned cast";
            case CTLZ -> "ctlz ";
            case MINUS -> "-";
        };
    }
}
