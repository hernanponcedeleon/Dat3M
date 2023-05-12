package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;

public class IExprBin extends IExpr {

    private final IExpr lhs;
    private final IExpr rhs;
    private final IOpBin op;

    public IExprBin(IExpr lhs, IOpBin op, IExpr rhs) {
    	Preconditions.checkArgument(lhs.getType().equals(rhs.getType()),
                "The types of %s and %s does not match", lhs, rhs);
        this.lhs = lhs;
        this.rhs = rhs;
        this.op = op;
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(lhs.getRegs()).addAll(rhs.getRegs()).build();
    }

    @Override
    public String toString() {
        return "(" + lhs + " " + op + " " + rhs + ")";
    }

	@Override
	public Type getType() {
		return lhs.getType();
	}
	
	public IOpBin getOp() {
		return op;
	}
	
	public IExpr getRHS() {
		return rhs;
	}

	public IExpr getLHS() {
		return lhs;
	}

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public int hashCode() {
    	if(op.equals(IOpBin.R_SHIFT)) {
    		return lhs.hashCode() >>> rhs.hashCode();
    	}
        return (op.combine(BigInteger.valueOf(lhs.hashCode()), BigInteger.valueOf(rhs.hashCode()))).intValue();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        IExprBin expr = (IExprBin) obj;
        return expr.op == op && expr.lhs.equals(lhs) && expr.rhs.equals(rhs);
    }
}
