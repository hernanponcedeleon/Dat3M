package com.dat3m.dartagnan.program.event.core.utils;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.List;

public interface MultiRegWriter extends Event {

    List<Register> getResultRegisters();
    void setResultRegister(int index, Register reg);
}
