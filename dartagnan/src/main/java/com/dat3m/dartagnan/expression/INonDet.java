package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.google.common.primitives.UnsignedInteger;
import com.google.common.primitives.UnsignedLong;

// TODO why is INonDet not a IConst?
public class INonDet extends IExpr {

    private final INonDetTypes type;
    private final int precision;

    public INonDet(INonDetTypes type, int precision) {
        this.type = type;
        this.precision = precision;
    }

    public INonDetTypes getNonDetType() {
        return type;
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        switch(type){
            case INT:
                return "nondet_int()";
            case UINT:
                return "nondet_uint()";
            case LONG:
                return "nondet_long()";
            case ULONG:
                return "nondet_ulong()";
            case SHORT:
                return "nondet_short()";
            case USHORT:
                return "nondet_ushort()";
            case CHAR:
                return "nondet_char()";
            case UCHAR:
                return "nondet_uchar()";
        }
        throw new UnsupportedOperationException("toString() not supported for " + this);
    }

    public long getMin() {
        switch(type){
            case UINT:
            case ULONG:
            case USHORT:
            case UCHAR:
                return 0;
            case INT:
                return Integer.MIN_VALUE;
            case LONG:
                return Long.MIN_VALUE;
            case SHORT:
                return Short.MIN_VALUE;
            case CHAR:
                return -128;
        }
        throw new UnsupportedOperationException("getMin() not supported for " + this);
    }

    public long getMax() {
        switch(type){
            case INT:
                return Integer.MAX_VALUE;
            case UINT:
                return UnsignedInteger.MAX_VALUE.longValue();
            case LONG:
                return Long.MAX_VALUE;
            case ULONG:
                return UnsignedLong.MAX_VALUE.longValue();
            case SHORT:
                return Short.MAX_VALUE;
            case USHORT:
                return 65535;
            case CHAR:
                return 127;
            case UCHAR:
                return 255;
        }
        throw new UnsupportedOperationException("getMax() not supported for " + this);
    }

    @Override
    public int getPrecision() {
        return precision;
    }
}
