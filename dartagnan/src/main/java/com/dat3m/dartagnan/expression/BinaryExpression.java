package com.dat3m.dartagnan.expression;

public interface BinaryExpression extends Expression {
    Expression getLeft();
    Expression getRight();
}
