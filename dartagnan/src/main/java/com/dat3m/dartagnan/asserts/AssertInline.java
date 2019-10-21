package com.dat3m.dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import com.dat3m.dartagnan.program.event.Local;

public class AssertInline extends AbstractAssert {
	
    private final Local e;

    public AssertInline(Local e){
        this.e = e;
    }

    @Override
    public BoolExpr encode(Context ctx) {
		return ctx.mkAnd(e.exec(), ctx.mkEq(e.getResultRegisterExpr(), ctx.mkInt(0)));
    }

    @Override
    public String toString(){
        return "!" + e.getResultRegister();
    }
}
