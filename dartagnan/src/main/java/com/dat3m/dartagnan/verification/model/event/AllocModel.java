package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.MemAlloc;
import com.dat3m.dartagnan.verification.model.ThreadModel;


public class AllocModel extends DefaultEventModel implements RegReaderModel, RegWriterModel {
    public AllocModel(MemAlloc event, ThreadModel thread, int id) {
        super(event, thread, id);
    }
}
