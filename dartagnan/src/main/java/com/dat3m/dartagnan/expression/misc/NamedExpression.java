package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.UnaryExpressionBase;
import com.google.common.base.Objects;
import com.google.common.base.Preconditions;

public class NamedExpression extends UnaryExpressionBase<Type, ExpressionKind.Other> {

    private final String name;

    public NamedExpression(String name, Expression expr) {
        super(expr.getType(), ExpressionKind.Other.NAMED, expr);
        this.name = Preconditions.checkNotNull(name, "name cannot be null");
    }

    public String getName() {
        return name;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitNamedExpression(this);
    }

    @Override
    public boolean equals(Object obj) {
        return super.equals(obj) && obj instanceof NamedExpression namedExpr && name.equals(namedExpr.getName());
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(super.hashCode(), name);
    }

    @Override
    public String toString() {
        return name;
    }
}
