package com.dat3m.dartagnan.expression.op;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum BoolUnaryOp implements ExpressionKind {
    NOT;

    @Override
    public String toString() {
       	return "!";
    }

    public boolean combine(boolean a){
       	return !a;
    }
}
