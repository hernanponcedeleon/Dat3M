package com.dat3m.dartagnan.model.events.threading;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.AbstractEventModel;

public final class ThreadReturnModel extends AbstractEventModel {

    private final TypedValue<?, ?> value;

    public ThreadReturnModel(TypedValue<?, ?> value) {
        this.value = value;
    }

    public TypedValue<?, ?> getValue() { return value;}

    @Override
    public String toString() {
        return String.format("return %s", value);
    }
}
