package com.dat3m.dartagnan.expression.booleans;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum BoolBinaryOp implements ExpressionKind {
    AND, OR;

    @Override
    public String getSymbol() {
        return switch (this) {
            case AND -> "&&";
            case OR -> "||";
        };
    }

    @Override
    public String toString() {
        return getSymbol();
    }

}
