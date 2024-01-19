package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.expression.type.BooleanType;

//TODO instances of this class should be managed by the program
public class NonDetBool extends BoolExpr {

    public NonDetBool(BooleanType type) {
        super(type);
    }

    @Override
    public String toString() {
        return "nondet_bool()";
    }

    @Override
    public <T> T accept(ExpressionVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
