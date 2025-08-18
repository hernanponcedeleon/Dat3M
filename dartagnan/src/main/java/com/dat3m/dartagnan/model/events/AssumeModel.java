package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.model.AbstractEventModel;

public final class AssumeModel extends AbstractEventModel {

    private final TypedValue<BooleanType, Boolean> value;

    public AssumeModel(TypedValue<BooleanType, Boolean> value) {
        this.value = value;
    }

    public TypedValue<BooleanType, Boolean> getValue() { return value; }

    @Override
    public String toString() {
        return String.format("Assume(%s)", value);
    }
}
