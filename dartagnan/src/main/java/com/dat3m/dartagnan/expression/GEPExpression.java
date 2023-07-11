package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.Type;

import java.util.List;

public final class GEPExpression implements Expression {

    private final Type type;
    private final Type indexingType;
    private final Expression base;
    private final List<Expression> offsets;

    public GEPExpression(Type t, Type e, Expression b, List<Expression> o) {
        type = t;
        indexingType = e;
        base = b;
        offsets = List.copyOf(o);
    }

    public Type getIndexingType() {
        return indexingType;
    }

    public Expression getBaseExpression() {
        return base;
    }

    public List<Expression> getOffsetExpressions() {
        return offsets;
    }

    @Override
    public Type getType() {
        return type;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        final StringBuilder string = new StringBuilder();
        string.append("GEP(").append(base);
        for (Expression offset : offsets) {
            string.append(", ").append(offset);
        }
        return string.append(")").toString();
    }
}
