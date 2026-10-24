package com.dat3m.dartagnan.model.event;

import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.model.ThreadModel;
import com.dat3m.dartagnan.model.ValueModel;


public class MemoryEventModel extends DefaultEventModel implements RegReaderModel {
    protected final ValueModel accessedAddress;
    protected final ValueModel value;

    public MemoryEventModel(
        MemoryEvent event, ThreadModel thread, int id, ValueModel address, ValueModel value) {
        super(event, thread, id);
        this.accessedAddress = address;
        this.value = value;
    }

    public ValueModel getAccessedAddress() {
        return accessedAddress;
    }

    public ValueModel getValue() {
        return value;
    }
}