package com.dat3m.dartagnan.expression.op;

import java.math.BigInteger;

public enum IntBinaryOp {
    ADD, SUB, MUL, DIV, UDIV, MOD, AND, OR, XOR, LSHIFT, RSHIFT, ARSHIFT, SREM, UREM;

    @Override
    public String toString() {
        return switch (this) {
            case ADD -> "+";
            case SUB -> "-";
            case MUL -> "*";
            case DIV -> "/";
            case MOD -> "%";
            case AND -> "&";
            case OR -> "|";
            case XOR -> "^";
            case LSHIFT -> "<<";
            case RSHIFT -> ">>>";
            case ARSHIFT -> ">>";
            default -> super.toString();
        };
    }

    public String getName() {
        return this.name().toLowerCase();
    }

    public static IntBinaryOp intToOp(int i) {
        return switch (i) {
            case 0 -> ADD;
            case 1 -> SUB;
            case 2 -> AND;
            case 3 -> OR;
            default -> throw new UnsupportedOperationException("The binary operator is not recognized");
        };
    }

    public BigInteger combine(BigInteger a, BigInteger b) {
        switch (this) {
            case ADD:
                return a.add(b);
            case SUB:
                return a.subtract(b);
            case MUL:
                return a.multiply(b);
            case DIV:
            case UDIV:
                return a.divide(b);
            case MOD:
                return a.mod(b);
            case SREM:
            case UREM:
                return a.remainder(b);
            case AND:
                return a.and(b);
            case OR:
                return a.or(b);
            case XOR:
                return a.xor(b);
            case LSHIFT:
                return a.shiftLeft(b.intValue());
            case RSHIFT:
                if (a.signum() < 0) {
                    // BigInteger does not support logical shift on negative values
                    throw new UnsupportedOperationException("No support for " + this + " on negative values.");
                }
                // For non-negative values, a logical shift is identical to a regular shift
            case ARSHIFT:
                return a.shiftRight(b.intValue());
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in IntBinaryOp");
    }
}
