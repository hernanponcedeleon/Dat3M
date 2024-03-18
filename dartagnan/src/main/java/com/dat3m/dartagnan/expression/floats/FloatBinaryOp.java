package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum FloatBinaryOp implements ExpressionKind {
    FADD, FSUB, FMUL, FDIV, FREM;

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
        };
    }

    public boolean isCommutative() {
        return switch (this) {
            case FADD, FMUL -> true;
            default -> false;
        };
    }
}
