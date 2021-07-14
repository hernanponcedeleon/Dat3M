package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BitvectorFormulaManager;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.IntegerFormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

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
    public BooleanFormula toZ3Bool(Event e, SolverContext ctx) {
        return op.encode(b1.toZ3Bool(e, ctx), b2.toZ3Bool(e, ctx), ctx);
    }

    @Override
    public Formula getLastValueExpr(SolverContext ctx){
        FormulaManager fmgr = ctx.getFormulaManager();
		IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
		BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
		
		BooleanFormula expr1 = b1.getLastValueExpr(ctx) instanceof BitvectorFormula ? 
				bvmgr.greaterThan((BitvectorFormula)b1.getLastValueExpr(ctx), bvmgr.makeBitvector(b1.getPrecision(), (BigInteger.ONE)), false):
				imgr.greaterThan((IntegerFormula)b1.getLastValueExpr(ctx), imgr.makeNumber(BigInteger.ONE));
       
		BooleanFormula expr2 = b2.getLastValueExpr(ctx) instanceof BitvectorFormula ? 
				bvmgr.greaterThan((BitvectorFormula)b2.getLastValueExpr(ctx), bvmgr.makeBitvector(b2.getPrecision(), (BigInteger.ONE)), false):
        		imgr.greaterThan((IntegerFormula)b2.getLastValueExpr(ctx), imgr.makeNumber(BigInteger.ONE));
        
		return fmgr.getBooleanFormulaManager().ifThenElse(op.encode(expr1, expr2, ctx), imgr.makeNumber(BigInteger.ONE), imgr.makeNumber(BigInteger.ZERO));
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
	public IConst reduce() {
    	BigInteger v1 = b1.reduce().getIntValue();
    	BigInteger v2 = b2.reduce().getIntValue();
		switch(op) {
        case AND:
        	return new IConst(v1.compareTo(BigInteger.ONE) == 0 ? v2 : BigInteger.ZERO, -1);
        case OR:
        	return new IConst(v1.compareTo(BigInteger.ONE) == 0 ? BigInteger.ONE : v2, -1);
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
        }
        if (obj == null || obj.getClass() != getClass())
            return false;
        BExprBin expr = (BExprBin) obj;
        return expr.op == op && expr.b1.equals(b1) && expr.b2.equals(b2);
    }
}
