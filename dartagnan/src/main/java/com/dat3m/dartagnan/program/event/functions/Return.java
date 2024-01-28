package com.dat3m.dartagnan.program.event.functions;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.RegReader;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

public class Return extends AbstractEvent implements RegReader {

    protected Expression expression; // May be NULL

    public Return(Expression expression) {
        this.expression = expression;
    }

    protected Return(Return other) {
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
        return hasValue() ? String.format("return %s", expression) : "return";
    }

    @Override
    public Return getCopy() {
        return new Return(this);
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
