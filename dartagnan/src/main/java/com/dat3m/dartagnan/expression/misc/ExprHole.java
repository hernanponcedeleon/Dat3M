package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;

/*
    A typed hole expression: can be used to make expression templates
    where the hole gets later replaced by some concrete expression of the correct type.
    TODO: Possibly add identifiers to allow to distinguish between different holes.
 */
public class ExprHole extends LeafExpressionBase<Type> {

    public ExprHole(Type type) {
        super(type);
    }

    @Override
    public ExpressionKind getKind() {
        return () -> "HOLE";
    }

    @Override
    public String toString() {
        return String.format("%s {_}", type);
    }

    @Override
    public boolean equals(Object obj) {
        return obj instanceof ExprHole other && type.equals(other.type);
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitExprHole(this);
    }
}
