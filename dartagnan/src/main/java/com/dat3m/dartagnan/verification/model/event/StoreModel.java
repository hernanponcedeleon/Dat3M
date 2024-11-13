package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;


public class StoreModel extends MemoryEventModel {
    private int coIndex = -1;

    public StoreModel(Event event) {
        super(event);
        assert event.hasTag(Tag.WRITE);
    }

    public int getCoherenceIndex() {
        return coIndex;
    }

    public void setCoherenceIndex(int index) {
        coIndex = index;
    }
}