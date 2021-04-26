package com.dat3m.dartagnan.expression.op;

import java.math.BigInteger;

import com.microsoft.z3.ArithExpr;
import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;

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

    public BoolExpr encode(Expr e1, Expr e2, Context ctx) {
        switch(this) {
            case EQ:
                return ctx.mkEq(e1, e2);
            case NEQ:
                return ctx.mkDistinct(e1, e2);
            case LT:
            	return e1.isBV() ? ctx.mkBVSLT((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkLt((ArithExpr)e1, (ArithExpr)e2);
            case ULT:
            	return e1.isBV() ? ctx.mkBVULT((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkLt((ArithExpr)e1, (ArithExpr)e2);
            case LTE:
                return e1.isBV() ? ctx.mkBVSLE((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkLe((ArithExpr)e1, (ArithExpr)e2);
            case ULTE:
                return e1.isBV() ? ctx.mkBVULE((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkLe((ArithExpr)e1, (ArithExpr)e2);
            case GT:
            	return e1.isBV() ? ctx.mkBVSGT((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkGt((ArithExpr)e1, (ArithExpr)e2);
            case UGT:
            	return e1.isBV() ? ctx.mkBVUGT((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkGt((ArithExpr)e1, (ArithExpr)e2);
            case GTE:
            	return e1.isBV() ? ctx.mkBVSGE((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkGe((ArithExpr)e1, (ArithExpr)e2);
            case UGTE:
            	return e1.isBV() ? ctx.mkBVUGE((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkGe((ArithExpr)e1, (ArithExpr)e2);
        }
        throw new UnsupportedOperationException("Encoding of not supported for COpBin " + this);
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
}
