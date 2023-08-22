package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;

public class Thread extends Function {

    // Optional fields
    // Scope hierarchy of the thread
    private final Optional<ScopeHierarchy> optScopeHierarchy;
    // Threads that are system-synchronized-with this thread
    private Optional<HashSet<Thread>> optSyncSet = Optional.empty();

    public Thread(String name, FunctionType funcType, List<String> parameterNames, int id, ThreadStart entry) {
        super(name, funcType, parameterNames, id, entry);
        Preconditions.checkArgument(id >= 0, "Invalid thread ID");
        Preconditions.checkNotNull(entry, "Thread entry event must be not null");
        this.optScopeHierarchy = Optional.empty();
    }

    public Thread(String name, FunctionType funcType, List<String> parameterNames, int id, ThreadStart entry,
                  ScopeHierarchy scopeHierarchy) {
        super(name, funcType, parameterNames, id, entry);
        Preconditions.checkArgument(id >= 0, "Invalid thread ID");
        Preconditions.checkNotNull(entry, "Thread entry event must be not null");
        this.optScopeHierarchy = Optional.of(scopeHierarchy);
    }

    public Optional<ScopeHierarchy> getOptScopeHierarchy() {
        return optScopeHierarchy;
    }

    public Optional<HashSet<Thread>> getOptSyncSet() {
        return optSyncSet;
    }

    public void setOptSyncSet(HashSet<Thread> optSyncSet) {
        this.optSyncSet = Optional.of(optSyncSet);
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
