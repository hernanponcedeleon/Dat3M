package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.ExpressionKind;

import java.math.BigInteger;

public enum IntCmpOp implements ExpressionKind {
    EQ, NEQ, GTE, LTE, GT, LT, UGTE, ULTE, UGT, ULT;

    @Override
    public String toString() {
        return getSymbol();
    }

    @Override
    public String getSymbol() {
        return switch (this) {
            case EQ -> "==";
            case NEQ -> "!=";
            case GTE, UGTE -> ">=";
            case LTE, ULTE -> "<=";
            case GT, UGT -> ">";
            case LT, ULT -> "<";
        };
    }

    public IntCmpOp inverted() {
        return switch (this) {
            case EQ -> NEQ;
            case NEQ -> EQ;
            case GTE -> LT;
            case UGTE -> ULT;
            case LTE -> GT;
            case ULTE -> UGT;
            case GT -> LTE;
            case UGT -> ULTE;
            case LT -> GTE;
            case ULT -> UGTE;
        };
    }

    public IntCmpOp reverse() {
        return switch (this) {
            case EQ, NEQ -> this;
            case GTE -> LTE;
            case UGTE -> ULTE;
            case LTE -> GTE;
            case ULTE -> UGTE;
            case GT -> LT;
            case UGT -> ULT;
            case LT -> GT;
            case ULT -> UGT;
        };
    }

    public boolean isSigned() {
        return switch (this) {
            case EQ, NEQ, GTE, LTE, GT, LT -> true;
            case UGTE, ULTE, UGT, ULT -> false;
        };
    }

    public boolean isStrict() {
        return switch (this) {
            case NEQ, LT, ULT, GT, UGT -> true;
            case EQ, LTE, ULTE, GTE, UGTE -> false;
        };
    }

    public boolean combine(BigInteger a, BigInteger b){
        return switch (this) {
            case EQ -> a.compareTo(b) == 0;
            case NEQ -> a.compareTo(b) != 0;
            case LT, ULT -> a.compareTo(b) < 0;
            case LTE, ULTE -> a.compareTo(b) <= 0;
            case GT, UGT -> a.compareTo(b) > 0;
            case GTE, UGTE -> a.compareTo(b) >= 0;
        };
    }

}
