package com.dat3m.dartagnan.program;

import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.google.common.base.Preconditions;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public class Thread extends Function {

    // Threads that are system-synchronized-with this thread
    private final Optional<Set<Thread>> syncSet;

    private ThreadHierarchy.Node position;
    public void setPosition(ThreadHierarchy.Node position) { this.position = position; }
    public ThreadHierarchy.Node getPosition() { return position; }

    public Thread(String name, FunctionType funcType, List<String> parameterNames, int id, ThreadStart entry) {
        super(name, funcType, parameterNames, id, entry);
        Preconditions.checkArgument(id >= 0, "Invalid thread ID");
        Preconditions.checkNotNull(entry, "Thread entry event must be not null");
        this.syncSet = Optional.empty();
    }

    public Thread(String name, FunctionType funcType, List<String> parameterNames, int id, ThreadStart entry, Set<Thread> syncSet) {
        super(name, funcType, parameterNames, id, entry);
        Preconditions.checkArgument(id >= 0, "Invalid thread ID");
        Preconditions.checkNotNull(entry, "Thread entry event must be not null");
        Preconditions.checkNotNull(syncSet, "Thread syncSet must be not null");
        this.syncSet = Optional.of(syncSet);
    }

    public boolean hasScope() {
        return true;
        // return scopeHierarchy.isPresent();
    }

    public boolean hasSyncSet() {
        return syncSet.isPresent();
    }

    public Set<Thread> getSyncSet() {
        return syncSet.get();
    }

    @Override
    public ThreadStart getEntry() {
        return (ThreadStart) entry;
    }

    @Override
    public String toString() {
        return String.format("T%d:%s", id, name);
    }

    public List<MemoryCoreEvent> getSpawningEvents() {
        final ThreadStart start = getEntry();
        if (!start.isSpawned()) {
            return List.of();
        }
        
        Event cur = start;
        while (!(cur instanceof Load startLoad)) { cur = cur.getSuccessor(); }
        cur = start.getCreator();
        while (!(cur instanceof Store startStore)) { cur = cur.getPredecessor(); }
        
        assert startStore.getAddress().equals(startLoad.getAddress());
        
        return List.of(startLoad, startStore);
    }
}
