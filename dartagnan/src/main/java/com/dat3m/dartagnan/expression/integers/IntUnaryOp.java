package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum IntUnaryOp implements ExpressionKind {
    CTLZ, CTTZ, MINUS;

    @Override
    public String toString() {
        return getSymbol();
    }

    @Override
    public String getSymbol() {
        return switch (this) {
            case CTLZ -> "ctlz ";
            case CTTZ -> "cttz ";
            case MINUS -> "-";
        };
    }
}
