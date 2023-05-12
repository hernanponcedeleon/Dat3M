package com.dat3m.dartagnan.expr;

public interface BinaryExpression extends Expression {

    default Expression getLeft() { return getOperands().get(0); }
    default Expression getRight() { return getOperands().get(1); }

}
