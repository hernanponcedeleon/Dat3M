package com.dat3m.dartagnan.prototype.expr;

public interface CastExpression extends UnaryExpression {

    default Type getSourceType() { return getOperand().getType(); }

}
