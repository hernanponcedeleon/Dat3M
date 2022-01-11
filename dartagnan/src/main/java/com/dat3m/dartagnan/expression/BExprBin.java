package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;

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
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(b1.getRegs()).addAll(b2.getRegs()).build();
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
