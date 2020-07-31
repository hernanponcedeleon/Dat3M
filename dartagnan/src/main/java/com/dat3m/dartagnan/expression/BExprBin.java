package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

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
    public BoolExpr toZ3Bool(Event e, Context ctx) {
        return op.encode(b1.toZ3Bool(e, ctx), b2.toZ3Bool(e, ctx), ctx);
    }

    @Override
    public Expr getLastValueExpr(Context ctx){
        BoolExpr expr1 = ctx.mkGt((IntExpr)b1.getLastValueExpr(ctx), ctx.mkInt(1));
        BoolExpr expr2 = ctx.mkGt((IntExpr)b2.getLastValueExpr(ctx), ctx.mkInt(1));
        return ctx.mkITE(op.encode(expr1, expr2, ctx), ctx.mkInt(1), ctx.mkInt(0));
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
    public boolean getBoolValue(Event e, Model model, Context ctx){
        return op.combine(b1.getBoolValue(e, model, ctx), b2.getBoolValue(e, model, ctx));
    }

    @Override
	public IConst reduce() {
		int v1 = b1.reduce().getValue();
		int v2 = b2.reduce().getValue();
		switch(op) {
        case AND:
        	return new IConst(v1 == 1 ? v2 : 0, -1);
        case OR:
        	return new IConst(v1 == 1 ? 1 : v2, -1);
        }
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}
}
