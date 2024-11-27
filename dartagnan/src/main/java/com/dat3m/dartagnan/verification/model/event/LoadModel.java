package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.verification.model.ThreadModel;

import java.math.BigInteger;


public class LoadModel extends MemoryEventModel implements RegWriterModel {
    private StoreModel readFrom;

    public LoadModel(
        Event event, ThreadModel thread, int id, BigInteger address, BigInteger value
    ) {
        super(event, thread, id, address, value);
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