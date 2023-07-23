package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.event.Tag;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

public class ScopeHierarchy{

    // There is a hierarchy of scopes, the order of keys
    // is important, thus we use a LinkedHashMap
    protected final Map<String, Integer> scopeIds = new LinkedHashMap<>();

    public ScopeHierarchy(Arch arch, int... ids) {
        switch (arch) {
            case PTX:
                this.scopeIds.put(Tag.PTX.SYS, 0);
                this.scopeIds.put(Tag.PTX.GPU, ids[0]);
                this.scopeIds.put(Tag.PTX.CTA, ids[1]);
                break;
            default:
                throw new UnsupportedOperationException("Scope hierarchy not implemented for architecture " + arch);
        }
    }

    public ArrayList<String> getScopes() {
        return new ArrayList<>(scopeIds.keySet());
    }

    public int getScopeId(String scope) {
        return scopeIds.getOrDefault(scope, -1);
    }

    // For each scope S higher than flag, we check both events are in the same scope S
    public boolean sameAtHigherScope(ScopeHierarchy thread, String flag) {
        if (!this.getClass().equals(thread.getClass()) || !this.getScopes().contains(flag)) {
            return false;
        }

        ArrayList<String> scopes = this.getScopes();
        int validIndex = scopes.indexOf(flag);
        // scopes(0) is highest in hierarchy
        // i = 0 is global, every thread will always have the same id, so start from i = 1
        for (int i = 1; i <= validIndex; i++) {
            if (!sameAtSingleScope(thread, scopes.get(i))) {
                return false;
            }
        }
        return true;
    }

    private boolean sameAtSingleScope(ScopeHierarchy thread, String scope) {
        int thisId = this.getScopeId(scope);
        int threadId = thread.getScopeId(scope);
        return (thisId == threadId && thisId != -1);
    }
}
