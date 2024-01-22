package com.dat3m.dartagnan.expression.op;

import java.math.BigInteger;

public enum CmpOp {
    EQ, NEQ, GTE, LTE, GT, LT, UGTE, ULTE, UGT, ULT;

    @Override
    public String toString() {
        return switch (this) {
            case EQ -> "==";
            case NEQ -> "!=";
            case GTE, UGTE -> ">=";
            case LTE, ULTE -> "<=";
            case GT, UGT -> ">";
            case LT, ULT -> "<";
        };
    }

    public CmpOp inverted() {
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

    public boolean isSigned() {
        return switch (this) {
            case EQ, NEQ, GTE, LTE, GT, LT -> true;
            case UGTE, ULTE, UGT, ULT -> false;
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
