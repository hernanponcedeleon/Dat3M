package com.dat3m.dartagnan.program.event.core.utils;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Event;

public interface RegWriter extends Event {

    Register getResultRegister();
}
