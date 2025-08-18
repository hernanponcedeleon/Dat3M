package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.model.AbstractEventModel;

public abstract class AbstractMemoryCoreEventModel extends AbstractEventModel {

    private final Type accessType;
    private final TypedValue<?, ?> address;

    protected AbstractMemoryCoreEventModel(Type accessType, TypedValue<?, ?> address) {
        this.accessType = accessType;
        this.address = address;
    }

    public TypedValue<?, ?> getAddress() { return address; }
    public Type getAccessType() { return accessType; }
}
