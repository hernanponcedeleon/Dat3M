package com.dat3m.dartagnan.expression.sql;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.program.Register;
import com.google.common.collect.ImmutableSet;

import java.util.List;

public class SqlExpression implements Expression {

    SqlKind kind;

    @Override
    public Type getType() {
        return null;
    }

    @Override
    public List<Expression> getOperands() {
        return List.of();
    }

    @Override
    public ExpressionKind getKind() {
        return kind;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return null;
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return Expression.super.getRegs();
    }
}
