package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.google.common.collect.ImmutableSet;

import static com.google.common.base.Preconditions.checkNotNull;

public final class BinaryIntegerExpression extends AbstractExpression {

    private final Expression lhs;
    private final Expression rhs;
    private final IOpBin op;

    BinaryIntegerExpression(Type type, Expression lhs, IOpBin op, Expression rhs) {
        super(type);
        this.lhs = checkNotNull(lhs);
        this.rhs = checkNotNull(rhs);
        this.op = checkNotNull(op);
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(lhs.getRegs()).addAll(rhs.getRegs()).build();
    }

    public IOpBin getOp() {
        return op;
    }

    public Expression getRHS() {
        return rhs;
    }

    public Expression getLHS() {
        return lhs;
    }

    @Override
    public <T> T visit(ExpressionVisitor<T> visitor) {
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
        BinaryIntegerExpression expr = (BinaryIntegerExpression) obj;
        return expr.op == op && expr.lhs.equals(lhs) && expr.rhs.equals(rhs);
    }

    @Override
    public String toString() {
        return "(" + lhs + " " + op + " " + rhs + ")";
    }
}
