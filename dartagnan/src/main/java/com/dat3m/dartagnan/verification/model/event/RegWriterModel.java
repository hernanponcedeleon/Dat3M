package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.Register;


public interface RegWriterModel extends EventModel {
    Register getResultRegister();
}