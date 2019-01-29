package com.dat3m.dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class AssertCompositeOr extends AbstractAssert {

    private AbstractAssert a1;
    private AbstractAssert a2;

    public AssertCompositeOr(AbstractAssert a1, AbstractAssert a2){
        this.a1 = a1;
        this.a2 = a2;
    }

    @Override
    public BoolExpr encode(Context ctx) {
        return ctx.mkOr(a1.encode(ctx), a2.encode(ctx));
    }

    @Override
    public String toString() {
        return "(" + a1 + " || " + a2 + ")";
    }

    @Override
    public AssertCompositeOr clone() {
        return new AssertCompositeOr(a1, a2);
    }
}
