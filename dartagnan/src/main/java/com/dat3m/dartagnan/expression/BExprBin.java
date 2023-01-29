package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;

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
    public BooleanFormula toBoolFormula(Event e, FormulaManager m) {
        return op.encode(b1.toBoolFormula(e, m), b2.toBoolFormula(e, m), m);
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
    public boolean getBoolValue(Event e, Model model, FormulaManager m) {
        return op.combine(b1.getBoolValue(e, model, m), b2.getBoolValue(e, model, m));
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
