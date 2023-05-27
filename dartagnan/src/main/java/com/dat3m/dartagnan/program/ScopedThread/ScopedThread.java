package com.dat3m.dartagnan.program.ScopedThread;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.ArrayList;
import java.util.HashMap;

public class ScopedThread extends Thread {

    protected final HashMap<String, Integer> scopeIds = new HashMap<>();
    protected final ArrayList<String> scopes = new ArrayList<>();

    public ScopedThread(String name, int id, Event entry) {
        super(name, id, entry);
    }

    public ScopedThread(int id, Event entry) {
        super(id, entry);
    }

    public ArrayList<String> getScopes() {
        return scopes;
    }

    public int getScopeIds(String scope) {
        return scopeIds.getOrDefault(scope, -1);
    }
}
