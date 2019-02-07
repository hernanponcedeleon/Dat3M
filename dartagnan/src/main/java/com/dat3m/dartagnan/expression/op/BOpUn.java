package com.dat3m.dartagnan.expression.op;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public enum BOpUn {
    NOT;

    @Override
    public String toString() {
        return "!";
    }

    public BoolExpr encode(BoolExpr e, Context ctx) {
        return ctx.mkNot(e);
    }

    public boolean combine(boolean a){
        return !a;
    }
}
