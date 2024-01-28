package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

import static com.google.common.base.Preconditions.checkArgument;

public class ITEExpr extends IntExpr {

    private final Expression guard;
    private final Expression tbranch;
    private final Expression fbranch;

    ITEExpr(Expression guard, Expression tbranch, Expression fbranch) {
        super(checkIntegerType(tbranch));
        checkArgument(guard.getType() instanceof BooleanType, "IfThenElse with non-boolean guard %s.", guard);
        checkArgument(tbranch.getType().equals(fbranch.getType()),
                "IfThenElse with mismatching branches %s and %s.", tbranch, fbranch);
        this.guard = guard;
        this.tbranch = tbranch;
        this.fbranch = fbranch;
    }

    private static IntegerType checkIntegerType(Expression tbranch) {
        if (tbranch.getType() instanceof IntegerType integerType) {
            return integerType;
        }
        throw new IllegalArgumentException(String.format("IfThenElse with non-integer branch %s.", tbranch));
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(guard.getRegs()).addAll(tbranch.getRegs()).addAll(fbranch.getRegs()).build();
    }

    @Override
    public String toString() {
        return "(if " + guard + " then " + tbranch + " else " + fbranch + ")";
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
    public <T> T accept(ExpressionVisitor<T> visitor) {
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
        ITEExpr expr = (ITEExpr) obj;
        return expr.guard.equals(guard) && expr.fbranch.equals(fbranch) && expr.tbranch.equals(tbranch);
    }
}
