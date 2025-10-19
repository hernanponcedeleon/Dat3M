package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.AbstractEventModel;
import com.dat3m.dartagnan.model.RegisterModel;

public final class LocalModel extends AbstractEventModel implements RegWriterModel {

    private final RegisterModel register;
    private final TypedValue<?, ?> value;

    public LocalModel(RegisterModel register, TypedValue<?, ?> value) {
        this.register = register;
        this.value = value;
    }

    @Override
    public RegisterModel getResultRegister() {
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
