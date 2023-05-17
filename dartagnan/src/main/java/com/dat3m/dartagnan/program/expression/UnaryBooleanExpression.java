package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.type.BooleanType;
import com.google.common.collect.ImmutableSet;

import static com.google.common.base.Preconditions.checkNotNull;

public final class UnaryBooleanExpression extends AbstractExpression {

    private final Expression b;
    private final BOpUn op;

    UnaryBooleanExpression(BooleanType type, BOpUn op, Expression b) {
        super(type);
        this.b = checkNotNull(b);
        this.op = checkNotNull(op);
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
        UnaryBooleanExpression expr = (UnaryBooleanExpression) obj;
        return expr.op == op && expr.b.equals(b);
    }

    @Override
    public String toString() {
        return "(" + op + " " + b + ")";
    }
}
