package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.Register.Read;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.Set;
import java.math.BigInteger;


public class MemoryEventModel extends DefaultEventModel implements RegReaderModel {
    protected BigInteger accessedAddress;
    protected BigInteger value;

    public MemoryEventModel(Event event) {
        super(event);
        assert event.hasTag(Tag.MEMORY);
    }

    public BigInteger getAccessedAddress() {
        return accessedAddress;
    }

    public void setAccessedAddress(BigInteger address) {
        accessedAddress = address;
    }

    public BigInteger getValue() {
        return value;
    }

    public void setValue(BigInteger value) {
        this.value = value;
    }

    @Override
    public Set<Read> getRegisterReads() {
        return ((RegReader) event).getRegisterReads();
    }
}