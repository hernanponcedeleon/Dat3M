package com.dat3m.dartagnan.expression.tangles;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum TangleType implements ExpressionKind {
    ALL, ANY, BROADCAST, IADD, IMUL, IAND, IOR, IXOR, SHUFFLE, BALLOT;

    @Override
    public String getSymbol() {
        return switch (this) {
            case ALL -> "all";
            case ANY -> "any";
            case BROADCAST -> "broadcast";
            case IADD -> "iAdd";
            case IMUL -> "iMul";
            case IAND -> "iAnd";
            case IOR -> "iOr";
            case IXOR -> "iXor";
            case SHUFFLE -> "shuffle";
            case BALLOT -> "ballot";
        };
    }

    @Override
    public String toString() {
        return getSymbol();
    }

}
