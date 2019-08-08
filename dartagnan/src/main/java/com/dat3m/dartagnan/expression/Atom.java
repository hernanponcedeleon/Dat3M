package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;

import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class Atom extends BExpr implements ExprInterface {
	
	private final ExprInterface lhs;
	private final ExprInterface rhs;
	private final COpBin op;
	
	public Atom (ExprInterface lhs, COpBin op, ExprInterface rhs) {
		this.lhs = lhs;
		this.rhs = rhs;
		this.op = op;
	}

    @Override
	public BoolExpr toZ3Bool(Event e, Context ctx) {
		return op.encode(lhs.toZ3Int(e, ctx), rhs.toZ3Int(e, ctx), ctx);
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx){
		return (IntExpr)ctx.mkITE(
				op.encode(lhs.getLastValueExpr(ctx), rhs.getLastValueExpr(ctx), ctx),
				ctx.mkInt(1),
				ctx.mkInt(0)
		);
	}

    @Override
	public ImmutableSet<Register> getRegs() {
		return new ImmutableSet.Builder<Register>().addAll(lhs.getRegs()).addAll(rhs.getRegs()).build();
	}

    @Override
    public String toString() {
        return lhs + " " + op + " " + rhs;
    }
    
    @Override
	public boolean getBoolValue(Event e, Context ctx, Model model){
		return op.combine(lhs.getIntValue(e, ctx, model), rhs.getIntValue(e, ctx, model));
	}
    
    public COpBin getOp() {
    	return op;
    }
    
    public ExprInterface getLHS() {
    	return lhs;
    }
    
    public ExprInterface getRHS() {
    	return rhs;
    }

    @Override
	public IConst reduce() {
		int v1 = lhs.reduce().getIntValue(null, null, null);
		int v2 = lhs.reduce().getIntValue(null, null, null);
        switch(op) {
        case EQ:
            return new IConst(v1 == v2 ? 1 : 0);
        case NEQ:
            return new IConst(v1 != v2 ? 1 : 0);
        case LT:
            return new IConst(v1 < v2 ? 1 : 0);
        case LTE:
            return new IConst(v1 <= v2 ? 1 : 0);
        case GT:
            return new IConst(v1 > v2 ? 1 : 0);
        case GTE:
            return new IConst(v1 >= v2 ? 1 : 0);
        }
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}
}