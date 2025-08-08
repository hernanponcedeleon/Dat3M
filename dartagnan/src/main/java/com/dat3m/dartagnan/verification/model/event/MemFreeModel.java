package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.MemFree;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.verification.model.ValueModel;


public class MemFreeModel extends DefaultEventModel implements RegReaderModel {
    private final ValueModel address;

    public MemFreeModel(MemFree event, ThreadModel thread, int id, ValueModel address) {
        super(event, thread, id);
        this.address = address;
    }

    public ValueModel getAddress() {
        return address;
    }
}
