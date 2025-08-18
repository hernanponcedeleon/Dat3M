package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.program.Register;

public final class LoadModel extends AbstractMemoryCoreEventModel implements RegWriterModel{

    private final Register register;
    private final TypedValue<?, ?> value;

    public LoadModel(Register register, TypedValue<?, ?> address, TypedValue<?, ?> value) {
        super(value.type(), address);
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
        return String.format("%s {%s} <- Load(%s)", register, value, getAddress());
    }
}
