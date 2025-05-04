package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.Type;
import com.google.common.base.Preconditions;

public record TypedValue<TType extends Type, TValue> (TType type, TValue value) {

    public TypedValue {
        Preconditions.checkNotNull(type);
        Preconditions.checkNotNull(value);
    }

    @Override
    public String toString() {
        return String.format("%s: %s", type, value);
    }

}
