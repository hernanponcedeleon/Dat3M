package com.dat3m.dartagnan.expression.pointers;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.type.PointerType;

public class NullLiteral extends LeafExpressionBase<PointerType> {

    public NullLiteral(PointerType type) {
        super(type);
    }

    @Override
    public ExpressionKind getKind() {
        return () -> "NULL";
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visitNullLiteral(this);
    }

    @Override
    public String toString() {
        return "nullptr";
    }
}
