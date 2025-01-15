package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.verification.model.ValueModel;


public class LocalModel extends DefaultEventModel implements RegReaderModel, RegWriterModel {
    private final ValueModel value;

    public LocalModel(Local event, ThreadModel thread, int id, ValueModel value) {
        super(event, thread, id);
        this.value = value;
    }

    @Override
    public Local getEvent() {
        return (Local) event;
    }

    public ValueModel getValue() {
        return value;
    }
}