package com.dat3m.dartagnan.program.event.arch.opencl;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.memory.MemoryObject;

public class OpenCLInit extends Init {
    public OpenCLInit(MemoryObject b, int o, Expression address) {
        super(b, o, address);
        if (b.getMemorySpace() != null) {
            addTags(b.getMemorySpace());
            if (b.isAtomic()) {
                addTags(Tag.C11.ATOMIC);
            }
        }
    }

}
