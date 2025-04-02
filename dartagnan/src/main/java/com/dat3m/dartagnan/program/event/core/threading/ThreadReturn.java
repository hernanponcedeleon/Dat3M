package com.dat3m.dartagnan.program.event.core.threading;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

public class ThreadReturn extends AbstractEvent implements RegReader {

    protected Expression expression; // May be NULL

    public ThreadReturn(Expression expression) {
        this.expression = expression;
    }

    protected ThreadReturn(ThreadReturn other) {
        super(other);
        this.expression = other.expression;
    }

    public boolean hasValue() {
        return expression != null;
    }

    public Optional<Expression> getValue() {
        return Optional.ofNullable(expression);
    }

    @Override
    protected String defaultString() {
        return hasValue() ? String.format("ThreadReturn %s", expression) : "ThreadReturn";
    }

    @Override
    public ThreadReturn getCopy() {
        return new ThreadReturn(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        if (!hasValue()) {
            return new HashSet<>();
        }
        return Register.collectRegisterReads(expression, Register.UsageType.DATA, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        if (expression != null) {
            expression = expression.accept(exprTransformer);
        }
    }
}
