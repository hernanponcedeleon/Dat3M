package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class IExprUn extends IExpr {

	private final ExprInterface b;
	private final IOpUn op;

    public IExprUn(IOpUn op, ExprInterface b) {
        this.b = b;
        this.op = op;
    }

	public IOpUn getOp() {
		return op;
	}

	public ExprInterface getInner() {
		return b;
	}

	@Override
	public Formula toIntFormula(Event e, SolverContext ctx) {
		return op.encode(b.toIntFormula(e, ctx), ctx);
	}

	@Override
	public Formula getLastValueExpr(SolverContext ctx) {
        return op.encode(b.getLastValueExpr(ctx), ctx);
	}

	@Override
	public BigInteger getIntValue(Event e, Model model, SolverContext ctx) {
        return b.getIntValue(e, model, ctx).negate();
	}

	@Override
	public ImmutableSet<Register> getRegs() {
        return b.getRegs();
	}
	@Override
	public ImmutableSet<Location> getLocs() {
		return b.getLocs();
	}

    @Override
    public String toString() {
        return "(" + op + b + ")";
    }

    @Override
	public IConst reduce() {
        switch(op){
			case MINUS:
				return new IConst(b.reduce().getIntValue().negate(), b.getPrecision());
			case BV2UINT:
			case INT2BV1: case INT2BV8: case INT2BV16: case INT2BV32: case INT2BV64: 
			case TRUNC6432: case TRUNC6416: case TRUNC648: case TRUNC641: case TRUNC3216: case TRUNC328: case TRUNC321: case TRUNC168: case TRUNC161: case TRUNC81:
			case ZEXT18: case ZEXT116: case ZEXT132: case ZEXT164: case ZEXT816: case ZEXT832: case ZEXT864: case ZEXT1632: case ZEXT1664: case ZEXT3264: 
			case SEXT18: case SEXT116: case SEXT132: case SEXT164: case SEXT816: case SEXT832: case SEXT864: case SEXT1632: case SEXT1664: case SEXT3264:
				return b.reduce();
			default:
		        throw new UnsupportedOperationException("Reduce not supported for " + this);				
        }
	}

	@Override
	public int getPrecision() {
		return b.getPrecision();
	}
	
	@Override
	public IExpr getBase() {
		throw new UnsupportedOperationException("getBase not supported for " + this);
	}

	@Override
	public <T> T visit(ExpressionVisitor<T> visitor) {
		return visitor.visit(this);
	}

	@Override
	public int hashCode() {
		return op.hashCode() ^ b.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
    	if (obj == this) {
    		return true;
		}
		if (obj == null || obj.getClass() != getClass())
			return false;
		IExprUn expr = (IExprUn) obj;
		return expr.op == op && expr.b.equals(b);
	}
}
