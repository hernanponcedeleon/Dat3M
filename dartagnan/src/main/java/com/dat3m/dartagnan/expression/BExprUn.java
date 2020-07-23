package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BitVecExpr;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.IntExpr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class BExprUn extends BExpr {

    private final ExprInterface b;
    private final BOpUn op;

    public BExprUn(BOpUn op, ExprInterface b) {
        this.b = b;
        this.op = op;
    }

    @Override
    public BoolExpr toZ3Bool(Event e, Context ctx, boolean bp) {
        return op.encode(b.toZ3Bool(e, ctx, bp), ctx);
    }

    @Override
    public Expr getLastValueExpr(Context ctx, boolean bp){
        BoolExpr expr = bp ? 
				ctx.mkBVSGT((BitVecExpr)b.getLastValueExpr(ctx, bp), ctx.mkBV(1,32)) : 
				ctx.mkGt((IntExpr)b.getLastValueExpr(ctx, bp), ctx.mkInt(1));
        return ctx.mkITE(op.encode(expr, ctx), ctx.mkInt(1), ctx.mkInt(0));
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return b.getRegs();
    }

    @Override
    public String toString() {
        return "(" + op + " " + b + ")";
    }

    @Override
    public boolean getBoolValue(Event e, Context ctx, Model model, boolean bp){
        return op.combine(b.getBoolValue(e, ctx, model, bp));
    }

	@Override
	public IConst reduce() {
		return new IConst(b.reduce().getValue());
	}
}
