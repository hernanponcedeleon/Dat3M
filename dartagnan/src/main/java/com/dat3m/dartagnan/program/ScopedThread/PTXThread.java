package com.dat3m.dartagnan.program.ScopedThread;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;

public class PTXThread extends ScopedThread {

    // There is a unique system level

    public PTXThread(String name, int id, Event entry, int GpuId, int CtaId) {
        super(name, id, entry);
        this.scopeIds.put(Tag.PTX.SYS, 0);
        this.scopeIds.put(Tag.PTX.GPU, GpuId);
        this.scopeIds.put(Tag.PTX.CTA, CtaId);
    }

    public PTXThread(int id, Event entry, int GpuId, int CtaId) {
        super(id, entry);
        this.scopeIds.put(Tag.PTX.SYS, 0);
        this.scopeIds.put(Tag.PTX.GPU, GpuId);
        this.scopeIds.put(Tag.PTX.CTA, CtaId);
    }
}
