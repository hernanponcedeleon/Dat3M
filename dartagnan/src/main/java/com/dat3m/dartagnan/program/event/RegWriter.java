package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.Register;

public interface RegWriter extends Event {

    Register getResultRegister();
    void setResultRegister(Register reg);
}
