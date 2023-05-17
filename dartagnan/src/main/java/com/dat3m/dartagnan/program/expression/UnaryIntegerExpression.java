package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.google.common.collect.ImmutableSet;

public final class UnaryIntegerExpression extends AbstractExpression {

    private final Expression b;
    private final IOpUn op;

    UnaryIntegerExpression(Type type, IOpUn op, Expression b) {
        super(type);
        this.b = b;
        this.op = op;
    }

    public IOpUn getOp() {
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
        } else if (!(obj instanceof UnaryIntegerExpression)) {
            return false;
        }
        UnaryIntegerExpression expr = (UnaryIntegerExpression) obj;
        return expr.op == op && expr.b.equals(b);
    }

    @Override
    public String toString() {
        return "(" + op + b + ")";
    }
}
