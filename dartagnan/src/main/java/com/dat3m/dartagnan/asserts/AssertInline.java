package com.dat3m.dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Assertion;
import com.dat3m.dartagnan.program.memory.Address;

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

	@Override
	public Set<Register> getRegs() {
		return new HashSet<Register>(Arrays.asList(e.getResultRegister()));
	}

	@Override
	public Set<Address> getAdds() {
		return new HashSet<Address>();
	}
}
