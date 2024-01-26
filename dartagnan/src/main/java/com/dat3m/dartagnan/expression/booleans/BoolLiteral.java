package com.dat3m.dartagnan.expression.booleans;

import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LiteralExpressionBase;
import com.dat3m.dartagnan.expression.type.BooleanType;

public final class BoolLiteral extends LiteralExpressionBase<BooleanType> {

    private final boolean value;

    public BoolLiteral(BooleanType type, boolean value) {
        super(type);
        this.value = value;
    }

    public boolean getValue() {
        return value;
    }

    @Override
    public String toString() {
        return value ? "True" : "False";
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitBoolLiteral(this);
    }

    @Override
    public int hashCode() {
        return Boolean.hashCode(value);
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof BoolLiteral lit && lit.value == this.value);
    }
}
