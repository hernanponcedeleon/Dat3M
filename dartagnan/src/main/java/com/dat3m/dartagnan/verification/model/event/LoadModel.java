package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.RegWriter;


public class LoadModel extends MemoryEventModel implements RegWriterModel {
    private StoreModel readFrom;

    public LoadModel(Event event) {
        super(event);
        assert event.hasTag(Tag.READ);
    }

    public StoreModel getReadFrom() {
        return readFrom;
    }

    public void setReadFrom(StoreModel store) {
        readFrom = store;
    }

    @Override
    public Register getResultRegister() {
        return ((RegWriter) event).getResultRegister();
    }
}