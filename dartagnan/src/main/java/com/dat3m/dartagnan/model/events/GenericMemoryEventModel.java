package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.encoding.TypedValue;
import com.dat3m.dartagnan.expression.Type;

public final class GenericMemoryEventModel extends AbstractMemoryCoreEventModel {

    private final String name;

    public GenericMemoryEventModel(String name, Type accessType, TypedValue<?, ?> address) {
        super(accessType, address);
        this.name = name;
    }

    public String getName() { return name; }
}
