package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.type.Type;

public interface CastExpression extends UnaryExpression {

    Type getSourceType();
    default Type getTargetType() { return getType(); }
}
