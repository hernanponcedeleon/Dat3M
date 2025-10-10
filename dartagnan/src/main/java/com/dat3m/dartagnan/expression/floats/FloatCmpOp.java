package com.dat3m.dartagnan.expression.floats;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum FloatCmpOp implements ExpressionKind {
    EQ, NEQ,
    OEQ, ONEQ, OGT, OGTE, OLT, OLTE, ORD, // Ordered comparisons (always false on NAN)
    UEQ, UNEQ, UGT, UGTE, ULT, ULTE, UNO; // Unordered comparisons (always true on NAN)

    @Override
    public String toString() {
        return getSymbol();
    }

    @Override
    public String getSymbol() {
        return switch (this) {
            case EQ -> "==";
            case NEQ -> "!=";
            case OEQ -> "o==";
            case ONEQ -> "o!=";
            case OGT -> "o>";
            case OGTE -> "o>=";
            case OLT -> "o<";
            case OLTE -> "o<=";
            case ORD -> "ord";
            case UEQ -> "u==";
            case UNEQ -> "u!=";
            case UGT -> "u>";
            case UGTE -> "u>=";
            case ULT -> "u<";
            case ULTE -> "u<=";
            case UNO -> "unord";
        };
    }

}
