package com.dat3m.dartagnan.verification.model.event;

import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.Register;


public interface RegWriterModel extends EventModel {
    default Register getResultRegister() {
        return ((RegWriter) this.getEvent()).getResultRegister();
    }
}