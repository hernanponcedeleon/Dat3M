package com.dat3m.dartagnan.program.expression;

import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

public final class ConditionalExpression extends AbstractExpression {

    private final Expression guard;
    private final Expression tbranch;
    private final Expression fbranch;
    private final ImmutableSet<Register> registers;

    ConditionalExpression(Expression guard, Expression tbranch, Expression fbranch) {
        super(tbranch.getType());
        checkArgument(guard.isBoolean(),
                "Expected boolean type for %s.", guard);
        checkArgument(tbranch.getType().equals(fbranch.getType()),
                "The types of %s and %s do not match", tbranch, fbranch);
        this.guard = checkNotNull(guard);
        this.tbranch = checkNotNull(tbranch);
        this.fbranch = checkNotNull(fbranch);
        this.registers = new ImmutableSet.Builder<Register>()
                .addAll(guard.getRegs()).addAll(tbranch.getRegs()).addAll(fbranch.getRegs()).build();
    }

    public Expression getGuard() {
        return guard;
    }

    public Expression getTrueBranch() {
        return tbranch;
    }

    public Expression getFalseBranch() {
        return fbranch;
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
        return guard.hashCode() ^ tbranch.hashCode() + fbranch.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        ConditionalExpression expr = (ConditionalExpression) obj;
        return expr.guard.equals(guard) && expr.fbranch.equals(fbranch) && expr.tbranch.equals(tbranch);
    }

    @Override
    public String toString() {
        return "(if " + guard + " then " + tbranch + " else " + fbranch + ")";
    }
}
