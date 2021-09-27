package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;

public class BExprBin extends BExpr {

    private final ExprInterface b1;
    private final ExprInterface b2;
    private final BOpBin op;

    public BExprBin(ExprInterface b1, BOpBin op, ExprInterface b2) {
        this.b1 = b1;
        this.b2 = b2;
        this.op = op;
    }

    public ExprInterface getLHS() {
    	return b1;
    }
    
    public ExprInterface getRHS() {
    	return b2;
    }
    
    public BOpBin getOp() {
    	return op;
    }

    @Override
    public BooleanFormula toBoolFormula(Event e, SolverContext ctx) {
        return op.encode(b1.toBoolFormula(e, ctx), b2.toBoolFormula(e, ctx), ctx);
    }

    @Override
    public Formula getLastValueExpr(SolverContext ctx){
        FormulaManager fmgr = ctx.getFormulaManager();
		
		BooleanFormula expr1 = b1.getLastValueExpr(ctx) instanceof BitvectorFormula ? 
				fmgr.getBitvectorFormulaManager().greaterThan((BitvectorFormula)b1.getLastValueExpr(ctx), fmgr.getBitvectorFormulaManager().makeBitvector(b1.getPrecision(), (BigInteger.ONE)), false):
				fmgr.getIntegerFormulaManager().greaterThan((IntegerFormula)b1.getLastValueExpr(ctx), fmgr.getIntegerFormulaManager().makeNumber(BigInteger.ONE));
       
		BooleanFormula expr2 = b2.getLastValueExpr(ctx) instanceof BitvectorFormula ? 
				fmgr.getBitvectorFormulaManager().greaterThan((BitvectorFormula)b2.getLastValueExpr(ctx), fmgr.getBitvectorFormulaManager().makeBitvector(b2.getPrecision(), (BigInteger.ONE)), false):
				fmgr.getIntegerFormulaManager().greaterThan((IntegerFormula)b2.getLastValueExpr(ctx), fmgr.getIntegerFormulaManager().makeNumber(BigInteger.ONE));
        
		return fmgr.getBooleanFormulaManager().ifThenElse(op.encode(expr1, expr2, ctx), 
				fmgr.getIntegerFormulaManager().makeNumber(BigInteger.ONE), 
				fmgr.getIntegerFormulaManager().makeNumber(BigInteger.ZERO));
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(b1.getRegs()).addAll(b2.getRegs()).build();
    }

    @Override
    public ImmutableSet<Location> getLocs() {
        return new ImmutableSet.Builder<Location>().addAll(b1.getLocs()).addAll(b2.getLocs()).build();
    }

    @Override
    public String toString() {
        return "(" + b1 + " " + op + " " + b2 + ")";
    }

    @Override
    public boolean getBoolValue(Event e, Model model, SolverContext ctx){
        return op.combine(b1.getBoolValue(e, model, ctx), b2.getBoolValue(e, model, ctx));
    }

    @Override
	public BConst reduce() {
    	boolean v1 = ((BConst)b1.reduce()).getValue();
    	boolean v2 = ((BConst)b2.reduce()).getValue();
		switch(op) {
        case AND:
        	return new BConst(v1 && v2);
        case OR:
        	return new BConst(v1 || v2);
        }
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public int hashCode() {
        return b1.hashCode() + b2.hashCode() + op.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        BExprBin expr = (BExprBin) obj;
        return expr.op == op && expr.b1.equals(b1) && expr.b2.equals(b2);
    }
}
