package com.dat3m.dartagnan.program.misc;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;

public class NonDetValue extends LeafExpressionBase<Type> {

    private final int id;

    public NonDetValue(Type type, int id) {
        super(type);
        this.id = id;
    }

    public int getId() { return id; }

    @Override
    public ExpressionKind getKind() {
        return ExpressionKind.Other.NONDET;
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitNonDetValue(this);
    }

    @Override
    public int hashCode() {
        return id;
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof NonDetValue other && this.id == other.id);
    }

    @Override
    public String toString() {
        return String.format("nondet_%s#%d", type, id);
    }
}
