package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.BoolUnaryOp;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

public class BoolUnaryExpr extends BoolExpr {

    private final Expression b;
    private final BoolUnaryOp op;

    BoolUnaryExpr(BooleanType type, BoolUnaryOp op, Expression b) {
        super(type);
        this.b = b;
        this.op = op;
    }

    public BoolUnaryOp getOp() {
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
    public <T> T accept(ExpressionVisitor<T> visitor) {
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
        BoolUnaryExpr expr = (BoolUnaryExpr) obj;
        return expr.op == op && expr.b.equals(b);
    }
}
