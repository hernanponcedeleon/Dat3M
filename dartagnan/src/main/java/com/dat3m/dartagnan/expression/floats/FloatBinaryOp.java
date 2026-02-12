package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum FloatBinaryOp implements ExpressionKind {
    FADD, FSUB, FMUL, FDIV, FREM, FMIN, FMAX;

    @Override
    public String toString() {
        return getSymbol();
    }

    @Override
    public String getSymbol() {
        return switch (this) {
            case FADD -> "+";
            case FSUB -> "-";
            case FMUL -> "*";
            case FDIV -> "/";
            case FREM -> "%";
            case FMAX -> "fmax ";
            case FMIN -> "fmin ";
        };
    }

    public boolean isCommutative() {
        return switch (this) {
            case FADD, FMUL -> true;
            default -> false;
        };
    }
}
