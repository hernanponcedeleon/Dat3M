package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;

public class IfExpr extends IExpr {

	private final BExpr guard;
	private final IExpr tbranch;
	private final IExpr fbranch;
	
	public IfExpr(BExpr guard, IExpr tbranch, IExpr fbranch) {
    	Preconditions.checkArgument(tbranch.getPrecision() == fbranch.getPrecision(), 
    			"The type of " + tbranch + " and " + fbranch + " does not match");
		this.guard =  guard;
		this.tbranch = tbranch;
		this.fbranch = fbranch;
	}

	@Override
	public Formula toIntFormula(Event e, SolverContext ctx) {
		return ctx.getFormulaManager().getBooleanFormulaManager().ifThenElse(
				guard.toBoolFormula(e, ctx), tbranch.toIntFormula(e, ctx), fbranch.toIntFormula(e, ctx));
	}

	@Override
	public BooleanFormula toBoolFormula(Event e, SolverContext ctx) {
		return ctx.getFormulaManager().getBooleanFormulaManager().ifThenElse(
				guard.toBoolFormula(e, ctx), tbranch.toBoolFormula(e, ctx), fbranch.toBoolFormula(e, ctx));
	}

	@Override
	public BigInteger getIntValue(Event e, Model model, SolverContext ctx) {
		return guard.getBoolValue(e, model, ctx) ? tbranch.getIntValue(e, model, ctx) : fbranch.getIntValue(e, model, ctx);
	}

	@Override
	public boolean getBoolValue(Event e, Model model, SolverContext ctx) {
		return guard.getBoolValue(e, model, ctx)? tbranch.getBoolValue(e, model, ctx) : fbranch.getBoolValue(e, model, ctx);
	}

	@Override
	public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(guard.getRegs()).addAll(tbranch.getRegs()).addAll(fbranch.getRegs()).build();
	}

    @Override
    public String toString() {
        return "(if " + guard + " then " + tbranch + " else " + fbranch + ")";
    }

	public BExpr getGuard() {
		return guard;
	}

	public IExpr getTrueBranch() {
		return tbranch;
	}

	public IExpr getFalseBranch() {
		return fbranch;
	}

	@Override
	public int getPrecision() {
		return tbranch.getPrecision();
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public int hashCode() {
		return guard.hashCode() ^ tbranch.hashCode() + fbranch.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {
			return true;
		} else if (obj == null || obj.getClass() != getClass()) {
			return false;
		}
		IfExpr expr = (IfExpr) obj;
		return expr.guard.equals(guard) && expr.fbranch.equals(fbranch) && expr.tbranch.equals(tbranch);
	}
}
