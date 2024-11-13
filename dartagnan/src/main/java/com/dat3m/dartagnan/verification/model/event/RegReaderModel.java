package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.Register.Read;

import java.util.Set;


public interface RegReaderModel extends EventModel {
    Set<Read> getRegisterReads();
}