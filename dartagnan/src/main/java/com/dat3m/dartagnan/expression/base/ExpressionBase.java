package com.dat3m.dartagnan.expression.base;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.common.NoInterface;
import com.google.common.collect.ImmutableSet;

import java.util.Objects;

@NoInterface
public abstract class ExpressionBase<TType extends Type> implements Expression {

    protected final TType type;

    protected ExpressionBase(TType type) {
        this.type = type;
    }

    @Override
    public TType getType() { return this.type; }

    @Override
    public ImmutableSet<Register> getRegs() {
        final ImmutableSet.Builder<Register> builder = ImmutableSet.builder();
        for (Expression expr : getOperands()) {
            builder.addAll(expr.getRegs());
        }
        return builder.build();
    }

    @Override
    public int hashCode() {
        return Objects.hash(type, getKind(), getOperands());
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }

        final Expression expr = (Expression) obj;
        return this.type.equals(expr.getType())
                && this.getKind().equals(expr.getKind())
                && this.getOperands().equals(expr.getOperands());
    }
}
