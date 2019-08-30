package com.dat3m.dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Assertion;
import com.google.common.collect.ImmutableSet;

public class AssertInline extends AbstractAssert {

    private final Assertion e;

    public AssertInline(Assertion e){
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
    
    public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of();
    }
}
