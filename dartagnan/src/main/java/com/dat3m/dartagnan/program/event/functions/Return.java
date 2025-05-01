package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

public class Return extends AbstractEvent implements RegReader {

    protected Expression expression;

    public Return(Expression expression) {
        this.expression =  Preconditions.checkNotNull(expression);
    }

    protected Return(Return other) {
        super(other);
        this.expression = other.expression;
    }

    public Optional<Expression> getValue() {
        return Optional.ofNullable(expression);
    }

    @Override
    protected String defaultString() {
        return  String.format("return %s", expression);
    }

    @Override
    public Return getCopy() {
        return new Return(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(expression, Register.UsageType.DATA, new HashSet<>());
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        expression = expression.accept(exprTransformer);
    }
}
