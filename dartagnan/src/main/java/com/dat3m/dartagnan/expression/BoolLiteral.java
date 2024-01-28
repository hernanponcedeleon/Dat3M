package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;

public final class BoolLiteral extends BoolExpr {

    private final boolean value;

    BoolLiteral(BooleanType type, boolean value) {
        super(type);
        this.value = value;
    }

    @Override
    public String toString() {
        return value ? "True" : "False";
    }

    public boolean getValue() {
        return value;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public int hashCode() {
        return Boolean.hashCode(value);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        } else if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        return ((BoolLiteral) obj).value == value;
    }
}
