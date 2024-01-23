package com.dat3m.dartagnan.expression.op;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum BoolBinaryOp implements ExpressionKind {
    AND, OR;

    @Override
    public String toString() {
        return switch (this) {
            case AND -> "&&";
            case OR -> "||";
        };
    }

    public boolean combine(boolean a, boolean b){
        return switch (this) {
            case AND -> a && b;
            case OR -> a || b;
        };
    }
}
