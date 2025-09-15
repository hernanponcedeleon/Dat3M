package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.MemAlloc;
import com.dat3m.dartagnan.verification.model.MemoryObjectModel;
import com.dat3m.dartagnan.verification.model.ThreadModel;


public class MemAllocModel extends DefaultEventModel implements RegReaderModel, RegWriterModel {
    private final MemoryObjectModel memoryObj;

    public MemAllocModel(MemAlloc event, ThreadModel thread, int id, MemoryObjectModel mo) {
        super(event, thread, id);
        memoryObj = mo;
    }

    public MemoryObjectModel getMemoryObject() {
        return memoryObj;
    }

    @Override
    public MemAlloc getEvent() {
        return (MemAlloc) event;
    }
}
