package com.dat3m.dartagnan.expression.misc;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.type.VoidType;

public class UnitExpr extends LeafExpressionBase<VoidType> {

    public UnitExpr(VoidType type) {
        super(type);
    }

    @Override
    public ExpressionKind getKind() {
        return () -> "UNIT";
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        // TODO ?
        return visitor.visitLeafExpression(this);
    }

    @Override
    public String toString() {
        return "unit";
    }
}
