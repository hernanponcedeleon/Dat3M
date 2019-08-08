package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;
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
	public IntExpr toZ3Int(Event e, Context ctx) {
		return (IntExpr)ctx.mkITE(guard.toZ3Bool(e, ctx), tbranch.toZ3Int(e, ctx), fbranch.toZ3Int(e, ctx));
	}

	@Override
	public BoolExpr toZ3Bool(Event e, Context ctx) {
		return (BoolExpr)ctx.mkITE(guard.toZ3Bool(e, ctx), tbranch.toZ3Bool(e, ctx), fbranch.toZ3Bool(e, ctx));
	}

	@Override
	public IntExpr getLastValueExpr(Context ctx) {
		// In principle this method is only called by assertions 
		// and thus it should never be called for this class
        throw new RuntimeException("Problem with getLastValueExpr in " + this.toString());
	}

	@Override
	public int getIntValue(Event e, Context ctx, Model model) {
		return guard.getBoolValue(e, ctx, model) ? tbranch.getIntValue(e, ctx, model) : fbranch.getIntValue(e, ctx, model);
	}

	@Override
	public boolean getBoolValue(Event e, Context ctx, Model model) {
		return guard.getBoolValue(e, ctx, model)? tbranch.getBoolValue(e, ctx, model) : fbranch.getBoolValue(e, ctx, model);
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
}
