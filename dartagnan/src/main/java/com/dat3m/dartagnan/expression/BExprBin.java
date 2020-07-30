package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;

public class BExprBin extends BExpr {

    private final ExprInterface b1;
    private final ExprInterface b2;
    private final BOpBin op;

    public BExprBin(ExprInterface b1, BOpBin op, ExprInterface b2) {
        this.b1 = b1;
        this.b2 = b2;
        this.op = op;
    }

    @Override
    public BoolExpr toZ3Bool(Event e, EncodingConf conf) {
        return op.encode(b1.toZ3Bool(e, conf), b2.toZ3Bool(e, conf), conf.getCtx());
    }

    @Override
    public Expr getLastValueExpr(EncodingConf conf){
    	Context ctx = conf.getCtx();
        BoolExpr expr1 = ctx.mkGt((IntExpr)b1.getLastValueExpr(conf), ctx.mkInt(1));
        BoolExpr expr2 = ctx.mkGt((IntExpr)b2.getLastValueExpr(conf), ctx.mkInt(1));
        return ctx.mkITE(op.encode(expr1, expr2, conf.getCtx()), ctx.mkInt(1), ctx.mkInt(0));
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(b1.getRegs()).addAll(b2.getRegs()).build();
    }

    @Override
    public String toString() {
        return "(" + b1 + " " + op + " " + b2 + ")";
    }

    @Override
    public boolean getBoolValue(Event e, Model model, EncodingConf conf){
        return op.combine(b1.getBoolValue(e, model, conf), b2.getBoolValue(e, model, conf));
    }

    @Override
	public IConst reduce() {
		int v1 = b1.reduce().getValue();
		int v2 = b2.reduce().getValue();
        int precision = b1.getPrecision();
		switch(op) {
        case AND:
        	return new IConst(v1 == 1 ? v2 : 0, precision);
        case OR:
        	return new IConst(v1 == 1 ? 1 : v2, precision);
        }
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public int getPrecision() {
		if(b1.getPrecision() != b2.getPrecision()) {
            throw new RuntimeException("The type of " + b1 + " and " + b2 + " does not match");
		}
		return b1.getPrecision();
	}
}
