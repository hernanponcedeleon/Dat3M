package com.dat3m.dartagnan.expression.op;

import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;

public enum IOpUn {
    MINUS;

    @Override
    public String toString() {
        return "-";
    }

    public Expr encode(Expr e, Context ctx, boolean bp) {
    	return bp ? ctx.mkBVSub(ctx.mkBV(0, 32), (BitVecExpr)e) : ctx.mkSub(ctx.mkInt(0), (IntExpr)e);
    }
}
