package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.verification.model.ThreadModel;

import java.util.Set;
import java.math.BigInteger;


public class MemoryEventModel extends DefaultEventModel implements RegReaderModel {
    protected final BigInteger accessedAddress;
    protected final BigInteger value;

    public MemoryEventModel(
        Event event, ThreadModel thread, int id, BigInteger address, BigInteger value
    ) {
        super(event, thread, id);
        assert event.hasTag(Tag.MEMORY);
        this.accessedAddress = address;
        this.value = value;
    }

    public BigInteger getAccessedAddress() {
        return accessedAddress;
    }

    public BigInteger getValue() {
        return value;
    }
}