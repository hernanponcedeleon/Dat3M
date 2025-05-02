package com.dat3m.dartagnan.expression.pointers;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum PointerCmpOp implements ExpressionKind {
    EQ, NEQ;

    @Override
    public String toString() {
        return getSymbol();
    }

    @Override
    public String getSymbol() {
        return switch (this) {
            case EQ -> "==";
            case NEQ -> "!=";
        };
    }
}
