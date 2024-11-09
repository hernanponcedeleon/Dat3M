package com.dat3m.dartagnan.expression.aggregates;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum AggregateCmpOp implements ExpressionKind {
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
