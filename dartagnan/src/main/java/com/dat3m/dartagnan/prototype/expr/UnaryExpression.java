package com.dat3m.dartagnan.prototype.expr;

public interface UnaryExpression extends Expression {

    default Expression getOperand() { return getOperands().get(0); }

}
