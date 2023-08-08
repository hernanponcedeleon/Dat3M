package com.dat3m.dartagnan.program.ScopedThread;

import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

//TODO: One could create a ScopeHierarchy class and let Thread have a (optional) member of that class.
// Then I think neither PTXThread nor ScopedThread would be needed anymore.
public class ScopedThread extends Thread {

    // There is a hierarchy of scopes, the order of keys
    // is important, thus we use a LinkedHashMap
    protected final Map<String, Integer> scopeIds = new LinkedHashMap<>();

    public ScopedThread(String name, FunctionType funcType, List<String> parameterNames, int id, ThreadStart entry) {
        super(name, funcType, parameterNames, id,  entry);
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
            if (!sameAtSingleScope(thread, scopes.get(i))) {
                return false;
            }
        }
        return true;
    }

    private boolean sameAtSingleScope(ScopedThread thread, String scope) {
        int thisId = this.getScopeId(scope);
        int threadId = thread.getScopeId(scope);
        return (thisId == threadId && thisId != -1);
    }
}
