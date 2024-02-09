package com.dat3m.dartagnan.expression.integers;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;

import java.math.BigInteger;

public enum IntBinaryOp implements ExpressionKind {
    ADD, SUB, MUL, DIV, UDIV, AND, OR, XOR, LSHIFT, RSHIFT, ARSHIFT, SREM, UREM;

    @Override
    public String toString() {
        return getSymbol();
    }

    @Override
    public String getSymbol() {
        return switch (this) {
            case ADD -> "+";
            case SUB -> "-";
            case MUL -> "*";
            case DIV -> "/";
            case AND -> "&";
            case OR -> "|";
            case XOR -> "^";
            case LSHIFT -> "<<";
            case RSHIFT -> ">>>";
            case ARSHIFT -> ">>";
            default -> super.toString();
        };
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

    public boolean isCommutative() {
        return switch (this) {
            case ADD, MUL, OR, XOR, AND -> true;
            default -> false;
        };
    }

    public BigInteger apply(BigInteger a, BigInteger b, int bitWidth) {
        return switch (this) {
            case ADD -> IntegerHelper.add(a, b, bitWidth);
            case SUB -> IntegerHelper.sub(a, b, bitWidth);
            case MUL -> IntegerHelper.mul(a, b, bitWidth);
            case DIV -> IntegerHelper.sdiv(a, b, bitWidth);
            case UDIV -> IntegerHelper.udiv(a, b, bitWidth);
            case SREM -> IntegerHelper.srem(a, b, bitWidth);
            case UREM -> IntegerHelper.urem(a, b, bitWidth);
            case AND -> IntegerHelper.and(a, b, bitWidth);
            case OR -> IntegerHelper.or(a, b, bitWidth);
            case XOR -> IntegerHelper.xor(a, b, bitWidth);
            case LSHIFT -> IntegerHelper.lshift(a, b, bitWidth);
            case RSHIFT -> IntegerHelper.rshift(a, b, bitWidth);
            case ARSHIFT -> IntegerHelper.arshift(a, b, bitWidth);
        };
    }
}
