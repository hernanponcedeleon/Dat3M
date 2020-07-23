package com.dat3m.dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class AssertTrue extends AbstractAssert {

    @Override
    public BoolExpr encode(Context ctx, boolean bp) {
    	// We want the verification to succeed so it should be UNSAT
        return ctx.mkFalse();
    }

    @Override
    public String toString(){
        return "true";
    }
}
