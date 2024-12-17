package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.verification.model.ThreadModel;


public class AssertModel extends DefaultEventModel implements RegReaderModel {
    private final boolean result;

    public AssertModel(Assert event, ThreadModel thread, int id, boolean result) {
        super(event, thread, id);
        this.result = result;
    }

    public boolean getResult() {
        return result;
    }
}