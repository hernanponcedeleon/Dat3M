package com.dat3m.dartagnan.expression.op;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum Kind implements ExpressionKind {
    LITERAL,
    CAST,
    NONDET,
    GEP,
    CONSTRUCT,
    ITE,
    EXTRACT,
    FUNCTION_ADDR,
    MEMORY_ADDR,
    REGISTER,
    OTHER
}
