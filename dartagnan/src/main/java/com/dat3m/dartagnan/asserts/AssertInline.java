package com.dat3m.dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.dat3m.dartagnan.program.event.Local;
import com.dat3m.dartagnan.utils.EncodingConf;

public class AssertInline extends AbstractAssert {
	
    private final Local e;

    public AssertInline(Local e){
        this.e = e;
    }

    @Override
    public BoolExpr encode(EncodingConf conf) {
    	Context ctx = conf.getCtx();
		return ctx.mkAnd(e.exec(), ctx.mkEq(e.getResultRegisterExpr(), ctx.mkInt(0)));
    }

    @Override
    public String toString(){
        return "!" + e.getResultRegister();
    }
}
