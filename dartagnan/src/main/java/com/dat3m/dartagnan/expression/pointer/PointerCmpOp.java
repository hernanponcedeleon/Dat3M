package com.dat3m.dartagnan.expression.pointer;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum PointerCmpOp implements ExpressionKind {
    EQ, NEQ, GTE, LTE, GT, LT;

    @Override
    public String toString() {
        return getSymbol();
    }

    @Override
    public String getSymbol() {
        return switch (this) {
            case EQ -> "==";
            case NEQ -> "!=";
            case GTE -> ">=";
            case LTE -> "<=";
            case GT -> ">";
            case LT -> "<";
        };
    }
}

