package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;

public final class InitModel extends StoreModel {
    public InitModel(TypedValue<?, ?> address, TypedValue<?, ?> value) {
        super(address, value);
    }

    @Override
    public String toString() {
        return String.format("Init(%s, %s)", getAddress(), getValue());
    }
}
