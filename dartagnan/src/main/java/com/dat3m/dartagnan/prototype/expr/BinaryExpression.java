package com.dat3m.dartagnan.prototype.expr;

public interface BinaryExpression extends Expression {

    default Expression getLeft() { return getOperands().get(0); }
    default Expression getRight() { return getOperands().get(1); }

}
