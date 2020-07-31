package com.dat3m.dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.dat3m.dartagnan.program.event.Local;

public class AssertInline extends AbstractAssert {
	
    private final Local e;

    public AssertInline(Local e){
        this.e = e;
    }

    @Override
    public BoolExpr encode(Context ctx) {
    	Expr expr = e.getResultRegisterExpr().isBV() ? ctx.mkBV(0, e.getResultRegister().getPrecision()) : ctx.mkInt(0); 
		return ctx.mkAnd(e.exec(), ctx.mkEq(e.getResultRegisterExpr(), expr));
    }

    @Override
    public String toString(){
        return "!" + e.getResultRegister();
    }
}
