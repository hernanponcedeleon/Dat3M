package com.dat3m.dartagnan.program.ScopedThread;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

public class ScopedThread extends Thread {

    // There is a hierarchy of scopes, the order of keys
    // is important, thus we use a LinkedHashMapeMap
    protected final Map<String, Integer> scopeIds = new LinkedHashMap<>();

    public ScopedThread(String name, int id, Event entry) {
        super(name, id, entry);
    }

    public ScopedThread(int id, Event entry) {
        super(id, entry);
    }

    public ArrayList<String> getScopes() {
        return new ArrayList<>(scopeIds.keySet());
    }

    public int getScopeIds(String scope) {
        return scopeIds.getOrDefault(scope, -1);
    }
}
