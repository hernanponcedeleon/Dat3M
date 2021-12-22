package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.parsers.program.exception.ExprTypeMismatchException;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;

public class Atom extends BExpr implements ExprInterface {
	
	private final ExprInterface lhs;
	private final ExprInterface rhs;
	private final COpBin op;
	
	public Atom (ExprInterface lhs, COpBin op, ExprInterface rhs) {
		this.lhs = lhs;
		this.rhs = rhs;
		this.op = op;
	}

    @Override
	public BooleanFormula toBoolFormula(Event e, SolverContext ctx) {
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
        return lhs + " " + op + " " + rhs;
    }
    
    @Override
	public boolean getBoolValue(Event e, Model model, SolverContext ctx){
		return op.combine(lhs.getIntValue(e, model, ctx), rhs.getIntValue(e, model, ctx));
	}
    
    public COpBin getOp() {
    	return op;
    }
    
    public ExprInterface getLHS() {
    	return lhs;
    }
    
    public ExprInterface getRHS() {
    	return rhs;
    }

    @Override
	public BConst reduce() {
    	// Reduction for IExpr
    	if(lhs instanceof IExpr && rhs instanceof IExpr) {
        	BigInteger v1 = ((IExpr)lhs).reduce().getIntValue();
        	BigInteger v2 = ((IExpr)lhs).reduce().getIntValue();
            switch(op) {
            	case EQ:
            		return new BConst(v1.compareTo(v2) == 0);
            	case NEQ:
            		return new BConst(v1.compareTo(v2) != 0);
	            case LT:
	            case ULT:
	                return new BConst(v1.compareTo(v2) < 0);
	            case LTE:
	            case ULTE:
	                return new BConst(v1.compareTo(v2) <= 0);
	            case GT:
	            case UGT:
	                return new BConst(v1.compareTo(v2) > 0);
	            case GTE:
	            case UGTE:
	                return new BConst(v1.compareTo(v2) >= 0);
	            default:
	                throw new UnsupportedOperationException("Reduce not supported for " + this);
            }            
    	}
    	// Reduction for BExpr
    	if(lhs instanceof BConst && rhs instanceof BConst) {
    		boolean v1 = ((BConst)lhs).reduce().getValue();
    		boolean v2 = ((BConst)lhs).reduce().getValue();
            switch(op) {
	            case EQ:
	            	return new BConst(v1 == v2);
	            case NEQ:
	            	return new BConst(v1 != v2);
	            default:
	                throw new UnsupportedOperationException("Reduce not supported for " + this);
            }
    	}
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public int getPrecision() {
		if(lhs.getPrecision() != rhs.getPrecision()) {
            throw new ExprTypeMismatchException("The type of " + lhs + " and " + rhs + " does not match");
		}
		return lhs.getPrecision();
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public int hashCode() {
		return op.hashCode() * lhs.hashCode() + rhs.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == this) {
			return true;
		} else if (obj == null || obj.getClass() != getClass()) {
			return false;
		}
		Atom expr = (Atom) obj;
		return expr.op == op && expr.lhs.equals(lhs) && expr.rhs.equals(rhs);
	}
}