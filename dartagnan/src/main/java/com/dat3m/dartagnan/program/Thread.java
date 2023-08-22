package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.google.common.base.Preconditions;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public class Thread extends Function {

    // Optional fields
    // Scope hierarchy of the thread
    private final Optional<ScopeHierarchy> optScopeHierarchy;

    private final boolean hasScope;
    // Threads that are system-synchronized-with this thread
    private final Optional<Set<Thread>> optSyncSet;

    public Thread(String name, FunctionType funcType, List<String> parameterNames, int id, ThreadStart entry) {
        super(name, funcType, parameterNames, id, entry);
        Preconditions.checkArgument(id >= 0, "Invalid thread ID");
        Preconditions.checkNotNull(entry, "Thread entry event must be not null");
        this.optScopeHierarchy = Optional.empty();
        this.optSyncSet = Optional.empty();
        this.hasScope = false;
    }

    public Thread(String name, FunctionType funcType, List<String> parameterNames, int id, ThreadStart entry,
                  ScopeHierarchy scopeHierarchy, Set<Thread> syncSet) {
        super(name, funcType, parameterNames, id, entry);
        Preconditions.checkArgument(id >= 0, "Invalid thread ID");
        Preconditions.checkNotNull(entry, "Thread entry event must be not null");
        Preconditions.checkNotNull(scopeHierarchy, "Thread scopeHierarchy must be not null");
        Preconditions.checkNotNull(syncSet, "Thread syncSet must be not null");
        this.optScopeHierarchy = Optional.of(scopeHierarchy);
        this.optSyncSet = Optional.of(syncSet);
        this.hasScope = true;
    }

    public boolean hasScope() {
        return hasScope;
    }

    // Invoke optional fields getters only if they are present
    public ScopeHierarchy getScopeHierarchy() {
        return optScopeHierarchy.get();
    }

    public Set<Thread> getSyncSet() {
        return optSyncSet.get();
    }

    @Override
    public ThreadStart getEntry() {
        return (ThreadStart) entry;
    }

    @Override
    public String toString() {
        return String.format("T%d:%s", id, name);
    }
}
