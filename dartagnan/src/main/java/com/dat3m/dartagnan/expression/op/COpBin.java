package com.dat3m.dartagnan.expression.op;

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

    public String fullName(){
        switch(this){
            case EQ:
                return "eq";
            case NEQ:
                return "neq";
            case GTE:
                return "sge";
            case UGTE:
                return "uge";
            case LTE:
                return "sle";
            case ULTE:
                return "ule";
            case GT:
                return "sgt";
            case UGT:
                return "ugt";
            case LT:
                return "slt";
            case ULT:
                return "ult";
        }
    	throw new UnsupportedOperationException("Full op name is not defined for " + this);
    }

    public BoolExpr encode(Expr e1, Expr e2, Context ctx, boolean bp) {
        switch(this) {
            case EQ:
                return ctx.mkEq(e1, e2);
            case NEQ:
                return ctx.mkNot(ctx.mkEq(e1, e2));
            case LT:
            	return bp ? ctx.mkBVSLT((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkLt((ArithExpr)e1, (ArithExpr)e2);
            case ULT:
            	return bp ? ctx.mkBVULT((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkLt((ArithExpr)e1, (ArithExpr)e2);
            case LTE:
                return bp ? ctx.mkBVSLE((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkLe((ArithExpr)e1, (ArithExpr)e2);
            case ULTE:
                return bp ? ctx.mkBVULE((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkLe((ArithExpr)e1, (ArithExpr)e2);
            case GT:
            	return bp ? ctx.mkBVSGT((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkGt((ArithExpr)e1, (ArithExpr)e2);
            case UGT:
            	return bp ? ctx.mkBVUGT((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkGt((ArithExpr)e1, (ArithExpr)e2);
            case GTE:
            	return bp ? ctx.mkBVSGE((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkGe((ArithExpr)e1, (ArithExpr)e2);
            case UGTE:
            	return bp ? ctx.mkBVUGE((BitVecExpr)e1, (BitVecExpr)e2) : ctx.mkGe((ArithExpr)e1, (ArithExpr)e2);
        }
        throw new UnsupportedOperationException("Encoding of not supported for COpBin " + this);
    }

    public boolean combine(int a, int b){
        switch(this){
            case EQ:
                return a == b;
            case NEQ:
                return a != b;
            case LT:
            case ULT:
                return a < b;
            case LTE:
            case ULTE:
                return a <= b;
            case GT:
            case UGT:
                return a > b;
            case GTE:
            case UGTE:
                return a >= b;
        }
        throw new UnsupportedOperationException("Illegal operator " + this + " in COpBin");
    }
}
