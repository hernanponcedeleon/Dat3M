package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

public class BExprUn extends BExpr {

    private final Expression b;
    private final BOpUn op;

    public BExprUn(BooleanType type, BOpUn op, Expression b) {
        super(type);
        this.b = b;
        this.op = op;
    }

    public BOpUn getOp() {
        return op;
    }

    public Expression getInner() {
        return b;
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
