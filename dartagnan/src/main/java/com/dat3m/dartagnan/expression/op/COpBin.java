package com.dat3m.dartagnan.expression.op;

import java.math.BigInteger;

public enum COpBin {
    EQ, NEQ, GTE, LTE, GT, LT, UGTE, ULTE, UGT, ULT;

    @Override
    public String toString() {
        switch(this){
            case EQ:
                return "==";
            case NEQ:
                return "!=";
            case GTE:
            case UGTE:
                return ">=";
            case LTE:
            case ULTE:
                return "<=";
            case GT:
            case UGT:
                return ">";
            case LT:
            case ULT:
                return "<";
        }
        return super.toString();
    }

    public COpBin inverted() {
        switch(this){
            case EQ:
                return NEQ;
            case NEQ:
                return EQ;
            case GTE:
                return LT;
            case UGTE:
                return ULT;
            case LTE:
                return GT;
            case ULTE:
                return UGT;
            case GT:
                return LTE;
            case UGT:
                return ULTE;
            case LT:
                return GTE;
            case ULT:
                return UGTE;
            default:
                throw new UnsupportedOperationException(this + " cannot be inverted");
        }
    }

    public boolean isSigned() {
        switch(this){
            case EQ: case NEQ:
            case GTE: case LTE: case GT: case LT:
            	return true;
            case UGTE: case ULTE: case UGT: case ULT:
            	return false;
            default:
                throw new UnsupportedOperationException("isSigned() not implemented for " + this);
        }
    }

    public boolean combine(BigInteger a, BigInteger b){
        switch(this){
            case EQ:
                return a.compareTo(b) == 0;
            case NEQ:
                return a.compareTo(b) != 0;
            case LT:
            case ULT:
                return a.compareTo(b) < 0;
            case LTE:
            case ULTE:
                return a.compareTo(b) <= 0;
            case GT:
            case UGT:
                return a.compareTo(b) > 0;
            case GTE:
            case UGTE:
                return a.compareTo(b) >= 0;
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in COpBin");
    }

    // Due to constant propagation, and the lack of a proper type system
    // we can end up with comparisons like "False == 1", thus the following two methods
    public boolean combine(boolean a, BigInteger b){
        switch(this){
            case EQ:
                return ((b.compareTo(BigInteger.ONE) == 0) == a);
            case NEQ:
                return ((b.compareTo(BigInteger.ONE) == 0) != a);
		default:
	        throw new UnsupportedOperationException("Illegal operator " + this + " in COpBin");
        }
    }

    public boolean combine(BigInteger a, boolean b){
        switch(this){
            case EQ:
                return ((a.compareTo(BigInteger.ONE) == 0) == b);
            case NEQ:
                return ((a.compareTo(BigInteger.ONE) == 0) != b);
		default:
	        throw new UnsupportedOperationException("Illegal operator " + this + " in COpBin");
        }
    }
}
