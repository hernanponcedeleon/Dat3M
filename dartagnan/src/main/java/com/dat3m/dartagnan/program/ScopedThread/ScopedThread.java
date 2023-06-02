package com.dat3m.dartagnan.program.ScopedThread;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.Event;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

public class ScopedThread extends Thread {

    // There is a hierarchy of scopes, the order of keys
    // is important, thus we use a LinkedHashMap
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

    public int getScopeId(String scope) {
        return scopeIds.getOrDefault(scope, -1);
    }

    // For each scope S higher than flag, we check both events are in the same scope S
    public boolean sameAtHigherScope(ScopedThread thread, String flag) {
        if (!this.getClass().equals(thread.getClass()) || !this.getScopes().contains(flag)) {
            return false;
        }
        ArrayList<String> scopes = this.getScopes();
        int validIndex = scopes.indexOf(flag);
        // scopes(0) is highest in hierarchy
        // i = 0 is global, every thread will always have the same id, so start from i = 1
        for (int i = 1; i <= validIndex; i++) {
            if (!sameAtSingleSameScope(thread, scopes.get(i))) {
                return false;
            }
        }
        return true;
    }

    private boolean sameAtSingleSameScope(ScopedThread thread, String scope) {
        int thisId = this.getScopeId(scope);
        int threadId = thread.getScopeId(scope);
        return (thisId == threadId && thisId != -1);
    }
}
