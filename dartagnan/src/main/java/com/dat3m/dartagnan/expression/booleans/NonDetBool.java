package com.dat3m.dartagnan.expression.booleans;

import com.dat3m.dartagnan.expression.ExpressionKind;
import com.dat3m.dartagnan.expression.base.LeafExpressionBase;
import com.dat3m.dartagnan.expression.op.Kind;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;

//TODO instances of this class should be managed by the program
public class NonDetBool extends LeafExpressionBase<BooleanType, Kind> {

    public NonDetBool(BooleanType type) {
        super(type);
    }

    @Override
    public ExpressionKind getKind() { return Kind.NONDET; }

    @Override
    public String toString() {
        return "nondet_bool()";
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
