package com.dat3m.dartagnan.expr;

public interface UnaryExpression extends Expression {

    default Expression getOperand() { return getOperands().get(0); }

}
