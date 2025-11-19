package com.dat3m.dartagnan.expression.pointer;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum PtrCmpOp implements ExpressionKind {
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
    public PtrCmpOp inverted() {
        return switch (this) {
            case EQ -> NEQ;
            case NEQ -> EQ;
            case GTE -> LT;
            case LTE -> GT;
            case GT -> LTE;
            case LT -> GTE;
        };
    }
    public PtrCmpOp reverse() {
        return switch (this) {
            case EQ, NEQ -> this;
            case GTE -> LTE;
            case LTE -> GTE;
            case GT -> LT;
            case LT -> GT;
        };
    }
    public boolean isStrict() {
        return switch (this) {
            case NEQ, LT, GT -> true;
            case EQ, LTE, GTE -> false;
        };
    }

    public boolean isLessCategory() {
        return switch (this) {
            case LT, LTE-> true;
            default -> false;
        };
    }
}

