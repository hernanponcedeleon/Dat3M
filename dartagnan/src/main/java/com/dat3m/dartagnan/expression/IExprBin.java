package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import java.math.BigInteger;

public class IExprBin extends IExpr implements ExprInterface {

    private final IExpr lhs;
    private final IExpr rhs;
    private final IOpBin op;

    public IExprBin(IExpr lhs, IOpBin op, IExpr rhs) {
    	Preconditions.checkArgument(lhs.getPrecision() == rhs.getPrecision(), "The type of " + lhs + " and " + rhs + " does not match");
        this.lhs = lhs;
        this.rhs = rhs;
        this.op = op;
    }

    @Override
    public Formula toIntFormula(Event e, SolverContext ctx) {
        return op.encode(lhs.toIntFormula(e, ctx), rhs.toIntFormula(e, ctx), ctx);
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(lhs.getRegs()).addAll(rhs.getRegs()).build();
    }

    @Override
    public ImmutableSet<Location> getLocs() {
        return new ImmutableSet.Builder<Location>().addAll(lhs.getLocs()).addAll(rhs.getLocs()).build();
    }

    @Override
    public String toString() {
        return "(" + lhs + " " + op + " " + rhs + ")";
    }

    @Override
    public BigInteger getIntValue(Event e, Model model, SolverContext ctx){
        return op.combine(lhs.getIntValue(e, model, ctx), rhs.getIntValue(e, model, ctx));
    }
    
    @Override
	public IConst reduce() {
    	BigInteger v1 = lhs.reduce().getIntValue();
    	BigInteger v2 = rhs.reduce().getIntValue();
		return new IConst(op.combine(v1, v2), lhs.getPrecision());
	}

	@Override
	public int getPrecision() {
		return lhs.getPrecision();
	}
	
	@Override
	public IExpr getBase() {
		return lhs.getBase();
	}
	
	@Override
	public IExpr simplify() {
		if(op.equals(IOpBin.PLUS) && lhs instanceof IExprBin && ((IExprBin)lhs).getOp().equals(IOpBin.PLUS)) {
			if(new IExprBin(((IExprBin)lhs).getRHS(), IOpBin.PLUS, rhs).reduce().equals(IConst.ZERO)) {
				return ((IExprBin)lhs).getLHS();
			}
			return new IExprBin(((IExprBin)lhs).getLHS(), IOpBin.PLUS, new IExprBin(((IExprBin)lhs).getRHS(), IOpBin.PLUS, rhs).reduce());
		}
		return new IExprBin(lhs, op, rhs.reduce());
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
