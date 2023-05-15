package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.AbstractExpression;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;

import static com.google.common.base.Preconditions.checkNotNull;

public class IExprBin extends AbstractExpression {

    private final Expression lhs;
    private final Expression rhs;
    private final IOpBin op;

    public IExprBin(Type type, Expression lhs, IOpBin op, Expression rhs) {
        super(type);
        this.lhs = checkNotNull(lhs);
        this.rhs = checkNotNull(rhs);
        this.op = checkNotNull(op);
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(lhs.getRegs()).addAll(rhs.getRegs()).build();
    }

    @Override
    public String toString() {
        return "(" + lhs + " " + op + " " + rhs + ")";
    }
	
	public IOpBin getOp() {
		return op;
	}
	
	public Expression getRHS() {
		return rhs;
	}

	public Expression getLHS() {
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
