package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum FloatUnaryOp implements ExpressionKind {
    NEG, FABS;

    @Override
    public String toString() {
        return getSymbol();
    }

    @Override
    public String getSymbol() {
        return switch (this) {
            case NEG -> "-";
            case FABS -> "fabs ";
        };
    }
}
