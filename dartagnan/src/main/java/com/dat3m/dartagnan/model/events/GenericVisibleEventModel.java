package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.model.AbstractEventModel;

public final class GenericVisibleEventModel extends AbstractEventModel {

    private final String name;

    public GenericVisibleEventModel(String name) {
        this.name = name;
    }

    public String getName() { return name; }
}
