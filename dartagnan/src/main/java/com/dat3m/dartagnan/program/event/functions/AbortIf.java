package com.dat3m.dartagnan.program.event.functions;


import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.Set;

/*
    Similar to Assume, but with explicit control-flow semantics.
 */
public class AbortIf extends AbstractEvent implements RegReader {

    private Expression condition;

    public AbortIf(Expression condition) {
        this.condition = Preconditions.checkNotNull(condition);
    }

    protected AbortIf(AbortIf other) {
        super(other);
        this.condition = other.condition;
    }

    public Expression getCondition() { return condition; }

    @Override
    protected String defaultString() {
        return String.format("abort if (%s)", condition);
    }

    @Override
    public AbortIf getCopy() {
        return new AbortIf(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(condition, Register.UsageType.CTRL, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.condition = condition.accept(exprTransformer);
    }
}
