package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.AbstractEventModel;
import com.dat3m.dartagnan.program.Register;

public final class LocalModel extends AbstractEventModel implements RegWriterModel {

    private final Register register;
    private final TypedValue<?, ?> value;

    public LocalModel(Register register, TypedValue<?, ?> value) {
        this.register = register;
        this.value = value;
    }

    @Override
    public Register getResultRegister() {
        return register;
    }

    @Override
    public TypedValue<?, ?> getValue() {
        return value;
    }

    @Override
    public String toString() {
        return String.format("%s {%s} <- %s", register, value, value);
    }

}
