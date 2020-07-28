package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;

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
	public BoolExpr toZ3Bool(Event e, EncodingConf conf) {
		return op.encode(lhs.toZ3NumExpr(e, conf), rhs.toZ3NumExpr(e, conf), conf);
	}

	@Override
	public Expr getLastValueExpr(EncodingConf conf){
		Context ctx = conf.getCtx();
		boolean bp = conf.getBP();
		return ctx.mkITE(
				op.encode(lhs.getLastValueExpr(conf), rhs.getLastValueExpr(conf), conf),
				bp ? ctx.mkBV(1, 32) : ctx.mkInt(1),
				bp ? ctx.mkBV(0, 32) : ctx.mkInt(0)
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
	public boolean getBoolValue(Event e, Model model, EncodingConf conf){
		return op.combine(lhs.getIntValue(e, model, conf), rhs.getIntValue(e, model, conf));
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
		int v1 = lhs.reduce().getValue();
		int v2 = lhs.reduce().getValue();
        switch(op) {
        case EQ:
            return new IConst(v1 == v2 ? 1 : 0);
        case NEQ:
            return new IConst(v1 != v2 ? 1 : 0);
        case LT:
        case ULT:
            return new IConst(v1 < v2 ? 1 : 0);
        case LTE:
        case ULTE:
            return new IConst(v1 <= v2 ? 1 : 0);
        case GT:
        case UGT:
            return new IConst(v1 > v2 ? 1 : 0);
        case GTE:
        case UGTE:
            return new IConst(v1 >= v2 ? 1 : 0);
        }
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}
}