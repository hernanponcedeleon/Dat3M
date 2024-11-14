package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.Register.Read;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.core.Assert;

import java.util.Set;


public class AssertModel extends DefaultEventModel implements RegReaderModel {
    public AssertModel(Assert event) {
        super(event);
    }

    @Override
    public Set<Read> getRegisterReads() {
        return ((RegReader) event).getRegisterReads();
    }
}