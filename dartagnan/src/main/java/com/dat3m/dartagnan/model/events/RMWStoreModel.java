package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;

public final class RMWStoreModel extends StoreModel {

    private final LoadModel load;

    public RMWStoreModel(LoadModel load, TypedValue<?, ?> address, TypedValue<?, ?> value) {
        super(address, value);
        this.load = load;
    }

    LoadModel getRMWLoadPartner() { return load; }

    @Override
    public String toString() {
        return String.format("RWMStore(%s, %s)", getAddress(), getValue());
    }
}
