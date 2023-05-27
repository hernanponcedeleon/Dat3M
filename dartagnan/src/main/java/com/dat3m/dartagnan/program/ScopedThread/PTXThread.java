package com.dat3m.dartagnan.program.ScopedThread;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;

public class PTXThread extends ScopedThread {

    public PTXThread(String name, int id, Event entry, int GpuId, int CtaId) {
        super(name, id, entry);
        // There is a unique system level
        this.scopeIds.put(Tag.PTX.SYS, 0);
        this.scopeIds.put(Tag.PTX.GPU, GpuId);
        this.scopeIds.put(Tag.PTX.CTA, CtaId);
    }

    public PTXThread(int id, Event entry, int GpuId, int CtaId) {
        super(id, entry);
        // There is a unique system level
        this.scopeIds.put(Tag.PTX.SYS, 0);
        this.scopeIds.put(Tag.PTX.GPU, GpuId);
        this.scopeIds.put(Tag.PTX.CTA, CtaId);
    }
}
