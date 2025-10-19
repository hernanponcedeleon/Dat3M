package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.model.RegisterModel;

public final class LoadModel extends AbstractMemoryCoreEventModel implements RegWriterModel{

    private final RegisterModel register;
    private final TypedValue<?, ?> value;

    public LoadModel(RegisterModel register, TypedValue<?, ?> address, TypedValue<?, ?> value) {
        super(value.type(), address);
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
        return String.format("%s {%s} <- Load(%s)", register, value, getAddress());
    }
}
