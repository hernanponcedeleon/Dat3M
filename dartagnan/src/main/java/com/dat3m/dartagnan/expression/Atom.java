package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

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
	public BooleanFormula toZ3Bool(Event e, SolverContext ctx) {
		return op.encode(lhs.toZ3Int(e, ctx), rhs.toZ3Int(e, ctx), ctx);
	}

	@Override
	public Formula getLastValueExpr(SolverContext ctx){
		boolean bp = getPrecision() > 0;
		FormulaManager fmgr = ctx.getFormulaManager();
		return bp? 
				fmgr.getBooleanFormulaManager().ifThenElse(op.encode(lhs.getLastValueExpr(ctx), rhs.getLastValueExpr(ctx), ctx), fmgr.getBitvectorFormulaManager().makeBitvector(getPrecision(), 1), fmgr.getBitvectorFormulaManager().makeBitvector(getPrecision(), 0)) :
				fmgr.getBooleanFormulaManager().ifThenElse(op.encode(lhs.getLastValueExpr(ctx), rhs.getLastValueExpr(ctx), ctx), fmgr.getIntegerFormulaManager().makeNumber(BigInteger.ONE), fmgr.getIntegerFormulaManager().makeNumber(BigInteger.ZERO));
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
	public IConst reduce() {
    	BigInteger v1 = lhs.reduce().getIntValue();
    	BigInteger v2 = rhs.reduce().getIntValue();
        switch(op) {
        case EQ:
            return new IConst(v1.compareTo(v2) == 0 ? BigInteger.ONE : BigInteger.ZERO, lhs.getPrecision());
        case NEQ:
            return new IConst(v1.compareTo(v2) != 0 ? BigInteger.ONE : BigInteger.ZERO, lhs.getPrecision());
        case LT:
        case ULT:
            return new IConst(v1.compareTo(v2) < 0 ? BigInteger.ONE : BigInteger.ZERO, lhs.getPrecision());
        case LTE:
        case ULTE:
            return new IConst(v1.compareTo(v2) <= 0 ? BigInteger.ONE : BigInteger.ZERO, lhs.getPrecision());
        case GT:
        case UGT:
            return new IConst(v1.compareTo(v2) > 0 ? BigInteger.ONE : BigInteger.ZERO, lhs.getPrecision());
        case GTE:
        case UGTE:
            return new IConst(v1.compareTo(v2) >= 0 ? BigInteger.ONE : BigInteger.ZERO, lhs.getPrecision());
        }
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

	@Override
	public int getPrecision() {
		if(lhs.getPrecision() != rhs.getPrecision()) {
            throw new RuntimeException("The type of " + lhs + " and " + rhs + " does not match");
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
		}
		if (obj == null || obj.getClass() != getClass())
			return false;
		Atom expr = (Atom) obj;
		return expr.op == op && expr.lhs.equals(lhs) && expr.rhs.equals(rhs);
	}
}