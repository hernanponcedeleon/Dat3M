package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;


public class FenceModel extends DefaultEventModel {
    private final String name;

    public FenceModel(Event event, String name) {
        super(event);
        assert event.hasTag(Tag.FENCE);
        this.name = name;
    }

    public String getName() {
        return name;
    }
}