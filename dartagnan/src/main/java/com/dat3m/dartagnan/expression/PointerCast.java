package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.PointerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

import static com.google.common.base.Preconditions.checkArgument;

public final class PointerCast implements Expression {

    private final Type type;
    private final Expression inner;
    private final boolean sign;

    PointerCast(Expression i, PointerType t, boolean s) {
        checkArgument(i.getType() instanceof IntegerType, "Cannot cast %s to %s", i, t);
        type = t;
        inner = i;
        sign = s;
    }

    PointerCast(Expression i, IntegerType t, boolean s) {
        checkArgument(i.getType() instanceof PointerType, "Cannot cast %s to %s", i, t);
        type = t;
        inner = i;
        sign = s;
    }

    public Expression getInnerExpression() { return inner; }

    public boolean isSigned() { return sign; }

    @Override
    public Type getType() {
        return type;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return inner.getRegs();
    }

    @Override
    public String toString() {
        return type + (sign ? "(s," : "(u,") + inner + ")";
    }
}
