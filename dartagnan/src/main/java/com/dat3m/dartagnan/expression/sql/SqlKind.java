package com.dat3m.dartagnan.expression.sql;

import com.dat3m.dartagnan.expression.ExpressionKind;

public enum SqlKind implements ExpressionKind {
    CREATE,
    INSERT,
    DELETE;

    @Override
    public String getSymbol() {
        return getName();
    }
}
