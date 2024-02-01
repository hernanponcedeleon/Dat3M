package com.dat3m.dartagnan.expression.booleans;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum BoolUnaryOp implements ExpressionKind {
    NOT;

    @Override
    public String toString() {
       	return getSymbol();
    }

    @Override
    public String getSymbol() {
        return "!";
    }
}
