package com.dat3m.dartagnan.program.event.core.utils;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.Set;

public interface RegReader extends Event {
    Set<Register.Read> getRegisterReads();
}
