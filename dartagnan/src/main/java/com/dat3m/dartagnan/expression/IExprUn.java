package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class IExprUn extends IExpr {

	private final ExprInterface b;
	private final IOpUn op;

    public IExprUn(IOpUn op, ExprInterface b) {
        this.b = b;
        this.op = op;
    }

	@Override
	public Expr toZ3NumExpr(Event e, Context ctx) {
		return op.encode(b.toZ3NumExpr(e, ctx), ctx);
	}

	@Override
	public Expr getLastValueExpr(Context ctx) {
        return op.encode(b.getLastValueExpr(ctx), ctx);
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model) {
        return -(b.getIntValue(e, ctx, model));
	}

	@Override
	public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(b.getRegs()).build();
	}

    @Override
    public String toString() {
        return "(" + op + b + ")";
    }

    @Override
	public IConst reduce() {
        switch(op){
		case MINUS:
			return new IConst(-b.reduce().getValue());
		default:
			throw new UnsupportedOperationException("Reduce not supported for " + this);
        }
	}
}
