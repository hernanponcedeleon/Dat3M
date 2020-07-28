package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;
import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.BoolExpr;
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
	public Expr toZ3Int(Event e, EncodingConf conf) {
		return conf.getCtx().mkITE(guard.toZ3Bool(e, conf), tbranch.toZ3Int(e, conf), fbranch.toZ3Int(e, conf));
	}

	@Override
	public BoolExpr toZ3Bool(Event e, EncodingConf conf) {
		return (BoolExpr)conf.getCtx().mkITE(guard.toZ3Bool(e, conf), tbranch.toZ3Bool(e, conf), fbranch.toZ3Bool(e, conf));
	}

	@Override
	public Expr getLastValueExpr(EncodingConf conf) {
		// In principle this method is only called by assertions 
		// and thus it should never be called for this class
        throw new RuntimeException("Problem with getLastValueExpr in " + this.toString());
	}

	@Override
	public int getIntValue(Event e, Model model, EncodingConf conf) {
		return guard.getBoolValue(e, model, conf) ? tbranch.getIntValue(e, model, conf) : fbranch.getIntValue(e, model, conf);
	}

	@Override
	public boolean getBoolValue(Event e, Model model, EncodingConf conf) {
		return guard.getBoolValue(e, model, conf)? tbranch.getBoolValue(e, model, conf) : fbranch.getBoolValue(e, model, conf);
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
