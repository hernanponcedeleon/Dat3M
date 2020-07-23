package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;

public class IfExpr implements ExprInterface {

	private BExpr guard;
	private ExprInterface tbranch;
	private ExprInterface fbranch;
	
	public IfExpr(BExpr guard, ExprInterface tbranch, ExprInterface fbranch) {
		this.guard =  guard;
		this.tbranch = tbranch;
		this.fbranch = fbranch;
	}

	@Override
	public Expr toZ3NumExpr(Event e, Context ctx, boolean bp) {
		return ctx.mkITE(guard.toZ3Bool(e, ctx, bp), tbranch.toZ3NumExpr(e, ctx, bp), fbranch.toZ3NumExpr(e, ctx, bp));
	}

	@Override
	public BoolExpr toZ3Bool(Event e, Context ctx, boolean bp) {
		return (BoolExpr)ctx.mkITE(guard.toZ3Bool(e, ctx, bp), tbranch.toZ3Bool(e, ctx, bp), fbranch.toZ3Bool(e, ctx, bp));
	}

	@Override
	public Expr getLastValueExpr(Context ctx, boolean bp) {
		// In principle this method is only called by assertions 
		// and thus it should never be called for this class
        throw new RuntimeException("Problem with getLastValueExpr in " + this.toString());
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model, boolean bp) {
		return guard.getBoolValue(e, ctx, model, bp) ? tbranch.getIntValue(e, ctx, model, bp) : fbranch.getIntValue(e, ctx, model, bp);
	}

	@Override
	public boolean getBoolValue(Event e, Context ctx, Model model, boolean bp) {
		return guard.getBoolValue(e, ctx, model, bp)? tbranch.getBoolValue(e, ctx, model, bp) : fbranch.getBoolValue(e, ctx, model, bp);
	}

	@Override
	public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(guard.getRegs()).addAll(tbranch.getRegs()).addAll(fbranch.getRegs()).build();
	}
	
    @Override
    public String toString() {
        return "(if " + guard + " then " + tbranch + " else " + fbranch + ")";
    }

	@Override
	public IConst reduce() {
		throw new UnsupportedOperationException("Reduce not supported for " + this);
	}
	
	public BExpr getGuard() {
		return guard;
	}
}
