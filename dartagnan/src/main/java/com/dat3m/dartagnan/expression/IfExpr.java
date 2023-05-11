package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.Expression;
import com.google.common.collect.ImmutableSet;

import static com.google.common.base.Preconditions.checkArgument;

public class IfExpr extends IExpr {

	private final Expression guard;
	private final IExpr tbranch;
	private final IExpr fbranch;
	
	public IfExpr(Expression guard, IExpr tbranch, IExpr fbranch) {
		checkArgument(guard.isBoolean(),
				"Expected boolean type for %s.", guard);
    	checkArgument(tbranch.getType().equals(fbranch.getType()),
    			"The types of %s and %s do not match", tbranch, fbranch);
		this.guard =  guard;
		this.tbranch = tbranch;
		this.fbranch = fbranch;
	}

	@Override
	public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(guard.getRegs()).addAll(tbranch.getRegs()).addAll(fbranch.getRegs()).build();
	}

    @Override
    public String toString() {
        return "(if " + guard + " then " + tbranch + " else " + fbranch + ")";
    }

	public Expression getGuard() {
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
