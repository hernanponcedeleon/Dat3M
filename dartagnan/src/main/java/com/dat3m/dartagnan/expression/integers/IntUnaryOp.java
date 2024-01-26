package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum IntUnaryOp implements ExpressionKind {
    CAST_SIGNED,
    CAST_UNSIGNED,
    CTLZ,
    MINUS;

    @Override
    public String toString() {
        return getSymbol();
    }

    @Override
    public String getSymbol() {
        return switch (this) {
            case CAST_SIGNED -> "signed cast";
            case CAST_UNSIGNED -> "unsigned cast";
            case CTLZ -> "ctlz ";
            case MINUS -> "-";
        };
    }
}
