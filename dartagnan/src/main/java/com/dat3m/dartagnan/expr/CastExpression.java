package com.dat3m.dartagnan.expr;

public interface CastExpression extends UnaryExpression {

    default Type getSourceType() { return getOperand().getType(); }

}
