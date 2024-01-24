package com.dat3m.dartagnan.expression.op;

public enum BoolBinaryOp {
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
