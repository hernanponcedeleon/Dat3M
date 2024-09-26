package com.dat3m.dartagnan.program.event.arch.c11;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.memory.MemoryObject;

public class OpenCLInit extends C11Init {
    public OpenCLInit(MemoryObject b, int o, Expression address) {
        super(b, o, address);
        if (b.getMemorySpace() != null) {
            addTags(b.getMemorySpace());
        }
    }

}
