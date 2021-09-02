package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.memory.Location;
import com.google.common.collect.ImmutableSet;

import java.math.BigInteger;

import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class BExprUn extends BExpr {

    private final ExprInterface b;
    private final BOpUn op;

    public BExprUn(BOpUn op, ExprInterface b) {
        this.b = b;
        this.op = op;
    }

    public BOpUn getOp() {
        return op;
    }

    public ExprInterface getInner() {
        return b;
    }

    @Override
    public BooleanFormula toBoolFormula(Event e, SolverContext ctx) {
        return op.encode(b.toBoolFormula(e, ctx), ctx);
    }

    @Override
    public Formula getLastValueExpr(SolverContext ctx){
    	FormulaManager fmgr = ctx.getFormulaManager();
		
		BooleanFormula expr = b.getLastValueExpr(ctx) instanceof BitvectorFormula ? 
				fmgr.getBitvectorFormulaManager().greaterThan((BitvectorFormula)b.getLastValueExpr(ctx), fmgr.getBitvectorFormulaManager().makeBitvector(b.getPrecision(), (BigInteger.ONE)), false):
				fmgr.getIntegerFormulaManager().greaterThan((IntegerFormula)b.getLastValueExpr(ctx), fmgr.getIntegerFormulaManager().makeNumber(BigInteger.ONE));
        
		return fmgr.getBooleanFormulaManager().ifThenElse(op.encode(expr, ctx), 
				fmgr.getIntegerFormulaManager().makeNumber(BigInteger.ONE), 
				fmgr.getIntegerFormulaManager().makeNumber(BigInteger.ZERO));
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
        return "(" + op + " " + b + ")";
    }

    @Override
    public boolean getBoolValue(Event e, Model model, SolverContext ctx){
        return op.combine(b.getBoolValue(e, model, ctx));
    }

	@Override
	public ExprInterface reduce() {
		return new BConst(!((BConst)b.reduce()).getValue());
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
        BExprUn expr = (BExprUn) obj;
        return expr.op == op && expr.b.equals(b);
    }
}
