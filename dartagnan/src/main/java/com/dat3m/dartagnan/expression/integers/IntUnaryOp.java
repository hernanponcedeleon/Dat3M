package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum IntUnaryOp implements ExpressionKind {
    CTPOP, CTLZ, CTTZ, NOT, MINUS;

    @Override
    public String toString() {
        return getSymbol();
    }

    @Override
    public String getSymbol() {
        return switch (this) {
            case CTPOP -> "ctpop ";
            case CTLZ -> "ctlz ";
            case CTTZ -> "cttz ";
            case NOT -> "~";
            case MINUS -> "-";
        };
    }
}
