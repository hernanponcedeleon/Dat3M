package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.CmpOp;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

public class Atom extends BoolExpr {

    private final Expression lhs;
    private final Expression rhs;
    private final CmpOp op;

    Atom(BooleanType type, Expression lhs, CmpOp op, Expression rhs) {
        super(type);
        this.lhs = lhs;
        this.rhs = rhs;
        this.op = op;
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(lhs.getRegs()).addAll(rhs.getRegs()).build();
    }

    @Override
    public String toString() {
        return lhs + " " + op + " " + rhs;
    }

    public CmpOp getOp() {
        return op;
    }

    public Expression getLHS() {
        return lhs;
    }

    public Expression getRHS() {
        return rhs;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
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