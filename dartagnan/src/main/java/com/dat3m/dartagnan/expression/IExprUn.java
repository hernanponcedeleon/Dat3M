package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.AbstractExpression;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;
import com.google.common.collect.ImmutableSet;

public class IExprUn extends AbstractExpression {

    private final Expression b;
    private final IOpUn op;

    public IExprUn(Type type, IOpUn op, Expression b) {
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
    public String toString() {
        return "(" + op + b + ")";
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
        IExprUn expr = (IExprUn) obj;
        return expr.op == op && expr.b.equals(b);
    }
}
