package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.verification.model.ThreadModel;


public class FenceModel extends DefaultEventModel {
    private final String name;

    public FenceModel(GenericVisibleEvent event, ThreadModel thread, int id, String name) {
        super(event, thread, id);
        assert event.hasTag(Tag.FENCE);
        this.name = name;
    }

    public String getName() {
        return name;
    }
}