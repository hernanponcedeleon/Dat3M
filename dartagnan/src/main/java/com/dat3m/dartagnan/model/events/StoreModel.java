package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;

public class StoreModel extends AbstractMemoryCoreEventModel {

    private final TypedValue<?, ?> value;

    public StoreModel(TypedValue<?, ?> address, TypedValue<?, ?> value) {
        super(value.type(), address);
        this.value = value;
    }

    public TypedValue<?, ?> getValue() { return value;}

    @Override
    public String toString() {
        return String.format("Store(%s, %s)", getAddress(), getValue());
    }
}
