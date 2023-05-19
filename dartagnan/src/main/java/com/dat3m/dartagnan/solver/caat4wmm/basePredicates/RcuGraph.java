package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

import java.util.List;
import java.util.Stack;
import java.util.stream.Stream;


// Linux specific graph that matches RCU-LOCK with RCU-UNLOCK
public class RcuGraph extends StaticWMMGraph {

    private BiMap<EventData, EventData> lockUnlockMap;
    private BiMap<EventData, EventData> unlockLockMap;

    @Override
    public int size(int id, EdgeDirection dir) {
        EventData e = getEvent(id);
        BiMap<EventData, EventData> map = dir == EdgeDirection.OUTGOING ? lockUnlockMap : unlockLockMap;
        return map.containsKey(e) ? 1 : 0;
    }

    @Override
    public boolean containsById(int id1, int id2) {
        return lockUnlockMap.get(getEvent(id1)) == getEvent(id2);
    }

    @Override
    public void repopulate() {
        this.lockUnlockMap = HashBiMap.create();
        this.unlockLockMap = lockUnlockMap.inverse();

        Stack<EventData> lastLocks = new Stack<>();
        for (List<EventData> events : model.getThreadEventsMap().values()) {
            for (EventData e : events) {
                if (e.is(Tag.Linux.RCU_LOCK)) {
                    lastLocks.push(e);
                } else if (e.is(Tag.Linux.RCU_UNLOCK)) {
                    if (!lastLocks.isEmpty()) {
                        lockUnlockMap.put(lastLocks.pop(), e);
                    } else {
                        throw new IllegalStateException("Unbalanced RCU-Locks: Unlock without preceding Lock");
                    }
                }
            }
            if (!lastLocks.isEmpty()) {
                throw new IllegalStateException("Unbalanced RCU-Locks: Lock without subsequent Unlock");
            }
        }
        size = lockUnlockMap.size();
    }

    @Override
    public Stream<Edge> edgeStream() {
        return lockUnlockMap.entrySet().stream().map(x -> new Edge(x.getKey().getId(), x.getValue().getId()));
    }

    @Override
    public Stream<Edge> edgeStream(int id, EdgeDirection dir) {
        EventData e = getEvent(id);
        BiMap<EventData, EventData> map = (dir == EdgeDirection.OUTGOING ? lockUnlockMap : unlockLockMap);
        EventData a = (dir == EdgeDirection.OUTGOING ? e : map.get(e));
        EventData b = (a == e ? map.get(e) : e);
        return (a != null && b != null) ? Stream.of(new Edge(a.getId(), b.getId())) : Stream.empty();
    }
}
