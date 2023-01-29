package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;

import java.math.BigInteger;

public class IExprBin extends IExpr {

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
    public Formula toIntFormula(Event e, FormulaManager m) {
        return op.encode(lhs.toIntFormula(e, m), rhs.toIntFormula(e, m), m);
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
    public BigInteger getIntValue(Event e, Model model, FormulaManager m) {
        return op.combine(lhs.getIntValue(e, model, m), rhs.getIntValue(e, model, m));
    }
    
    @Override
	public IConst reduce() {
    	BigInteger v1 = lhs.reduce().getValue();
    	BigInteger v2 = rhs.reduce().getValue();
		return new IValue(op.combine(v1, v2), lhs.getPrecision());
	}

	@Override
	public int getPrecision() {
		return lhs.getPrecision();
	}
	
	@Override
	public IExpr getBase() {
		return lhs.getBase();
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
