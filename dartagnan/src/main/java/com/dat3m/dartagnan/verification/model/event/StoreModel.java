package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.verification.model.ThreadModel;

import java.math.BigInteger;


public class StoreModel extends MemoryEventModel {
    private int coIndex = -1;

    public StoreModel(
        Event event, ThreadModel thread, int id, BigInteger address, BigInteger value
    ) {
        super(event, thread, id, address, value);
        assert event.hasTag(Tag.WRITE);
    }

    public int getCoherenceIndex() {
        return coIndex;
    }

    public void setCoherenceIndex(int index) {
        coIndex = index;
    }
}