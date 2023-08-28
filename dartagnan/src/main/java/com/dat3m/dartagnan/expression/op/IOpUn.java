package com.dat3m.dartagnan.expression.op;

public enum IOpUn {
    CAST_SIGNED,
    CAST_UNSIGNED,
    CTLZ,
    MINUS;

    @Override
    public String toString() {
        return switch (this) {
            case CAST_SIGNED -> "cast signed ";
            case CAST_UNSIGNED -> "cast unsigned ";
            case CTLZ -> "ctlz ";
            case MINUS -> "-";
        };
    }
}
