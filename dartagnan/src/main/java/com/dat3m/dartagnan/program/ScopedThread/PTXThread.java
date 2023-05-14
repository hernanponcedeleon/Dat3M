package com.dat3m.dartagnan.program.ScopedThread;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

public class PTXThread extends Thread implements ScopedThread {
    private final ArrayList<String> scopes =
            new ArrayList<>(Arrays.asList(Tag.PTX.SYS, Tag.PTX.GPU, Tag.PTX.CTA));
    private final HashMap<String, Integer> scopeIds = new HashMap<>();

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

    @Override
    public ArrayList<String> getScopes() {
        return scopes;
    }

    @Override
    public int getScopeIds(String scope) {
        if (!this.scopeIds.containsKey(scope)) {
            return -1;
        }
        return this.scopeIds.get(scope);
    }
}
