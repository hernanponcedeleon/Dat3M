package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.*;

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
    public ImmutableSet<Register> getRegs() {
        return b.getRegs();
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
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        BExprUn expr = (BExprUn) obj;
        return expr.op == op && expr.b.equals(b);
    }
}
