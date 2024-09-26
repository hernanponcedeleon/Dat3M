package com.dat3m.dartagnan.program.event.arch.c11;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.memory.MemoryObject;

public class C11Init extends Init {
    public C11Init(MemoryObject b, int o, Expression address) {
        super(b, o, address);
        addTags(Tag.C11.NONATOMIC); // Every initial event is a nonatomic write of zero
        if (!b.isAtomic()) {
            addTags(Tag.C11.NON_ATOMIC_LOCATION);
        }
    }

}
