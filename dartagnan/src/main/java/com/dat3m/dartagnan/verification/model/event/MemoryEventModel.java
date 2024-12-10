package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.verification.model.ValueModel;

import java.util.Set;
import java.math.BigInteger;


public class MemoryEventModel extends DefaultEventModel implements RegReaderModel {
    protected final BigInteger accessedAddress;
    protected final ValueModel value;

    public MemoryEventModel(
        MemoryEvent event, ThreadModel thread, int id, BigInteger address, ValueModel value) {
        super(event, thread, id);
        this.accessedAddress = address;
        this.value = value;
    }

    public BigInteger getAccessedAddress() {
        return accessedAddress;
    }

    public ValueModel getValue() {
        return value;
    }
}