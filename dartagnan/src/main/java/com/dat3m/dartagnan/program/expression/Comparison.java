package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.type.BooleanType;
import com.google.common.collect.ImmutableSet;

import static com.google.common.base.Preconditions.checkNotNull;

public final class Comparison extends AbstractExpression {

    private final Expression lhs;
    private final Expression rhs;
    private final COpBin op;
    private final ImmutableSet<Register> registers;

    Comparison(BooleanType type, Expression lhs, COpBin op, Expression rhs) {
        super(type);
        this.lhs = checkNotNull(lhs);
        this.rhs = checkNotNull(rhs);
        this.op = checkNotNull(op);
        this.registers = new ImmutableSet.Builder<Register>().addAll(lhs.getRegs()).addAll(rhs.getRegs()).build();
    }

    public COpBin getOp() {
        return op;
    }

    public Expression getLHS() {
        return lhs;
    }

    public Expression getRHS() {
        return rhs;
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return registers;
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
        } else if (!(obj instanceof Comparison)) {
            return false;
        }
        Comparison expr = (Comparison) obj;
        return expr.op == op && expr.lhs.equals(lhs) && expr.rhs.equals(rhs);
    }

    @Override
    public String toString() {
        return lhs + " " + op + " " + rhs;
    }
}