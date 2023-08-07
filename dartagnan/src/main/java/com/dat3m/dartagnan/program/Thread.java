package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.google.common.base.Preconditions;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public class Thread extends Function {

    public Thread(String name, FunctionType funcType, List<String> parameterNames, int id, ThreadStart entry) {
        super(name, funcType, parameterNames, id,  entry);
        Preconditions.checkArgument(id >= 0, "Invalid thread ID");
        Preconditions.checkNotNull(entry, "Thread entry event must be not null");
    }

    public Optional<ScopeHierarchy> optScopeHierarchy = Optional.empty();
    public Optional<Set<Thread>> optSyncSet = Optional.empty();

    @Override
    public ThreadStart getEntry() {
        return (ThreadStart) entry;
    }

    @Override
    public String toString() {
        return String.format("T%d:%s", id, name);
    }
}
