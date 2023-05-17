package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.expression.op.BOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.expression.type.BooleanType;
import com.google.common.collect.ImmutableSet;

import static com.google.common.base.Preconditions.checkNotNull;

public class BinaryBooleanExpression extends AbstractExpression {

    private final Expression b1;
    private final Expression b2;
    private final BOpBin op;
    private final ImmutableSet<Register> registers;

    BinaryBooleanExpression(BooleanType type, Expression b1, BOpBin op, Expression b2) {
        super(type);
        this.b1 = checkNotNull(b1);
        this.b2 = checkNotNull(b2);
        this.op = checkNotNull(op);
        this.registers = new ImmutableSet.Builder<Register>().addAll(b1.getRegs()).addAll(b2.getRegs()).build();
    }

    public Expression getLHS() {
        return b1;
    }

    public Expression getRHS() {
        return b2;
    }

    public BOpBin getOp() {
        return op;
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
        return b1.hashCode() + b2.hashCode() + op.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        BinaryBooleanExpression expr = (BinaryBooleanExpression) obj;
        return expr.op == op && expr.b1.equals(b1) && expr.b2.equals(b2);
    }

    @Override
    public String toString() {
        return "(" + b1 + " " + op + " " + b2 + ")";
    }
}
