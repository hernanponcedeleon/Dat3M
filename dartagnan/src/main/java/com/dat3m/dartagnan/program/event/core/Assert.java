package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegReader;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.Set;

public class Assert extends AbstractEvent implements RegReader {

    protected Expression expr;
    protected String errorMessage;

    public Assert(Expression expr, String errorMessage) {
        super();
        this.expr = Preconditions.checkNotNull(expr);
        this.errorMessage = Preconditions.checkNotNull(errorMessage);
    }

    protected Assert(Assert other) {
        super(other);
        this.expr = other.expr;
        this.errorMessage = other.errorMessage;
    }

    public Expression getExpression() {
        return expr;
    }
    public String getErrorMessage() { return errorMessage; }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return Register.collectRegisterReads(expr, Register.UsageType.OTHER, new HashSet<>());
    }

    @Override
    public String defaultString() {
        return String.format("assert(%s) ### %s", expr, errorMessage);
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        this.expr = expr.accept(exprTransformer);
    }

    @Override
    public Assert getCopy() {
        return new Assert(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitAssert(this);
    }
}