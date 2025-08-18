package com.dat3m.dartagnan.model.events;

import com.dat3m.dartagnan.model.AbstractEventModel;

public final class LabelModel extends AbstractEventModel {

    private final String name;

    public LabelModel(String name) {
        this.name = name;
    }

    public String getName() { return name; }

    @Override
    public String toString() {
        return name;
    }
}
