package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
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
	public Expr getLastValueExpr(Context ctx){
		boolean bp = getPrecision() > 0;
		return ctx.mkITE(
				op.encode(lhs.getLastValueExpr(ctx), rhs.getLastValueExpr(ctx), ctx),
				bp ? ctx.mkBV(1, getPrecision()) : ctx.mkInt(1),
				bp ? ctx.mkBV(0, getPrecision()) : ctx.mkInt(0)
		);

	}

    @Override
	public ImmutableSet<Register> getRegs() {
		return new ImmutableSet.Builder<Register>().addAll(lhs.getRegs()).addAll(rhs.getRegs()).build();
	}

	@Override
	public ImmutableSet<Location> getLocs() {
		return new ImmutableSet.Builder<Location>().addAll(lhs.getLocs()).addAll(rhs.getLocs()).build();
	}

    @Override
    public String toString() {
        return lhs + " " + op + " " + rhs;
    }
    
    @Override
	public boolean getBoolValue(Event e, Model model, Context ctx){
		return op.combine(lhs.getIntValue(e, model, ctx), rhs.getIntValue(e, model, ctx));
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
		long v1 = lhs.reduce().getValue();
		long v2 = rhs.reduce().getValue();
        switch(op) {
        case EQ:
            return new IConst(v1 == v2 ? 1 : 0, lhs.getPrecision());
        case NEQ:
            return new IConst(v1 != v2 ? 1 : 0, lhs.getPrecision());
        case LT:
        case ULT:
            return new IConst(v1 < v2 ? 1 : 0, lhs.getPrecision());
        case LTE:
        case ULTE:
            return new IConst(v1 <= v2 ? 1 : 0, lhs.getPrecision());
        case GT:
        case UGT:
            return new IConst(v1 > v2 ? 1 : 0, lhs.getPrecision());
        case GTE:
        case UGTE:
            return new IConst(v1 >= v2 ? 1 : 0, lhs.getPrecision());
        }
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public int getPrecision() {
		if(lhs.getPrecision() != rhs.getPrecision()) {
            throw new RuntimeException("The type of " + lhs + " and " + rhs + " does not match");
		}
		return lhs.getPrecision();
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public int hashCode() {
		return op.hashCode() * lhs.hashCode() + rhs.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {
			return true;
		}
		if (obj == null || obj.getClass() != getClass())
			return false;
		Atom expr = (Atom) obj;
		return expr.op == op && expr.lhs.equals(lhs) && expr.rhs.equals(rhs);
	}
}