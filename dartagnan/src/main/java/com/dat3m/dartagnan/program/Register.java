package com.dat3m.dartagnan.program;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

import static com.dat3m.dartagnan.utils.Settings.USEBV;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Event;

public class Register extends IExpr implements ExprInterface {

	private static int dummyCount = 0;

	private final String name;
    private final int threadId;

	public Register(String name, int threadId) {
		if(name == null){
			name = "DUMMY_REG_" + dummyCount++;
		}
		this.name = name;
		this.threadId = threadId;
	}
	
	public String getName() {
		return name;
	}

	public int getThreadId(){
		return threadId;
	}

	@Override
	public String toString() {
        return USEBV ? "bv." + name : name;
	}

    @Override
    public int hashCode(){
        return (name.hashCode() << 8) + threadId;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;

        if (obj == null || getClass() != obj.getClass())
            return false;

        Register rObj = (Register) obj;
        return name.equals(rObj.name) && threadId == rObj.threadId;
    }

	@Override
	public Expr toZ3NumExpr(Event e, Context ctx) {
		return USEBV ? ctx.mkBVConst(getName() + "(" + e.repr() + ")", 32) : ctx.mkIntConst(getName() + "(" + e.repr() + ")");
	}

	public Expr toZ3NumExprResult(Event e, Context ctx) {
		return USEBV ? ctx.mkBVConst(getName() + "(" + e.repr() + "_result)", 32) : ctx.mkIntConst(getName() + "(" + e.repr() + "_result)");
	}

	@Override
	public ImmutableSet<Register> getRegs() {
		return ImmutableSet.of(this);
	}

	@Override
	public Expr getLastValueExpr(Context ctx){
		return USEBV ? ctx.mkBVConst(getName() + "_" + threadId + "_final", 32) : ctx.mkIntConst(getName() + "_" + threadId + "_final");
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model){
		return Integer.parseInt(model.getConstInterp(toZ3NumExpr(e, ctx)).toString());
	}

	@Override
	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}
}
