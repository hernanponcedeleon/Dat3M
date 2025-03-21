package com.dat3m.dartagnan.expression;

public interface CastExpression extends UnaryExpression {

    Type getSourceType();
    default Type getTargetType() { return getType(); }
}
