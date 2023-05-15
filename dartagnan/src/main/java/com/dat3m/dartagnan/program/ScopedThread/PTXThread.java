package com.dat3m.dartagnan.program.ScopedThread;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.Arrays;

public class PTXThread extends ScopedThread {

    public PTXThread(String name, int id, Event entry, int GpuId, int CtaId) {
        super(name, id, entry);
        scopes.addAll(Arrays.asList(Tag.PTX.SYS, Tag.PTX.GPU, Tag.PTX.CTA));
        this.scopeIds.put(Tag.PTX.SYS, 0);
        this.scopeIds.put(Tag.PTX.GPU, GpuId);
        this.scopeIds.put(Tag.PTX.CTA, CtaId);
    }

    public PTXThread(int id, Event entry, int GpuId, int CtaId) {
        super(id, entry);
        scopes.addAll(Arrays.asList(Tag.PTX.SYS, Tag.PTX.GPU, Tag.PTX.CTA));
        this.scopeIds.put(Tag.PTX.SYS, 0);
        this.scopeIds.put(Tag.PTX.GPU, GpuId);
        this.scopeIds.put(Tag.PTX.CTA, CtaId);
    }
}
