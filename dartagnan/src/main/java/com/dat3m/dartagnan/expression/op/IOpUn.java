package com.dat3m.dartagnan.expression.op;

public enum IOpUn {
    MINUS,
    BV2UINT, BV2INT,
    INT2BV1, INT2BV8, INT2BV16, INT2BV32, INT2BV64,
    TRUNC6432, TRUNC6416, TRUNC648, TRUNC641, TRUNC3216, TRUNC328, TRUNC321, TRUNC168, TRUNC161, TRUNC81,
    ZEXT18, ZEXT116, ZEXT132, ZEXT164, ZEXT816, ZEXT832, ZEXT864, ZEXT1632, ZEXT1664, ZEXT3264,
    SEXT18, SEXT116, SEXT132, SEXT164, SEXT816, SEXT832, SEXT864, SEXT1632, SEXT1664, SEXT3264,
    CTLZ;

    @Override
    public String toString() {
        switch (this) {
            case MINUS:
                return "-";
            case CTLZ:
                return "ctlz ";
            default:
                return "";
        }
    }
}
