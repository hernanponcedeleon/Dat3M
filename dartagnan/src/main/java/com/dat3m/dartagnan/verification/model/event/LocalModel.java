package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Local;

import java.util.Set;


public class LocalModel extends DefaultEventModel implements RegReaderModel, RegWriterModel {
    public LocalModel(Local event) {
        super(event);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        return ((RegReader) event).getRegisterReads();
    }

    @Override
    public Register getResultRegister() {
        return ((RegWriter) event).getResultRegister();
    }
}