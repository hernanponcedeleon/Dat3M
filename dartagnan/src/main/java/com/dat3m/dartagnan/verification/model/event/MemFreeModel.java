package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.MemFree;
import com.dat3m.dartagnan.verification.model.ThreadModel;


public class MemFreeModel extends DefaultEventModel implements RegReaderModel {
    public MemFreeModel(MemFree event, ThreadModel thread, int id) {
        super(event, thread, id);
    }
}
