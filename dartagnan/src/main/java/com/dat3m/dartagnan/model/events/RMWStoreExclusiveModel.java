package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;

public final class RMWStoreExclusiveModel extends StoreModel {

    private final boolean isStrong;
    private final boolean didSucceed;

    public RMWStoreExclusiveModel(TypedValue<?, ?> address, TypedValue<?, ?> value, boolean isStrong, boolean didSucceed) {
        super(address, value);
        this.isStrong = isStrong;
        this.didSucceed = didSucceed;
    }

    public boolean isStrong() { return isStrong; }
    public boolean didSucceed() { return didSucceed; }

    @Override
    public String toString() {
        return String.format("RMWStoreExcl(%s, %s)%s", getAddress(), getValue(), didSucceed ? "" : " #FAIL");
    }
}
