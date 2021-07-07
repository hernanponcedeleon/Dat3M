package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.program.arch.linux.utils.EType;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.google.common.collect.BiMap;
import com.google.common.collect.HashBiMap;

import java.util.List;
import java.util.Stack;
import java.util.stream.Stream;


// Linux specific graph that matches RCU-LOCK with RCU-UNLOCK
public class RcuGraph extends StaticEventGraph {

    private final static FilterAbstract LOCK_FILTER = FilterBasic.get(EType.RCU_LOCK);
    private final static FilterAbstract UNLOCK_FILTER = FilterBasic.get(EType.RCU_UNLOCK);

    private BiMap<EventData, EventData> lockUnlockMap;
    private BiMap<EventData, EventData> unlockLockMap;

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        BiMap<EventData, EventData> map = dir == EdgeDirection.Outgoing ? lockUnlockMap : unlockLockMap;
        return map.containsKey(e) ? 1 : 0;
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return lockUnlockMap.get(a) == b;
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        this.lockUnlockMap = HashBiMap.create();
        this.unlockLockMap = lockUnlockMap.inverse();

        Stack<EventData> lastLocks = new Stack<>();
        for (List<EventData> events : model.getThreadEventsMap().values()) {
            for (EventData e : events) {
                if (LOCK_FILTER.filter(e.getEvent())) {
                    lastLocks.push(e);
                } else if (UNLOCK_FILTER.filter(e.getEvent())) {
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
        return lockUnlockMap.entrySet().stream().map(x -> new Edge(x.getKey(), x.getValue()));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        BiMap<EventData, EventData> map = dir == EdgeDirection.Outgoing ? lockUnlockMap : unlockLockMap;
        EventData a = dir == EdgeDirection.Outgoing ? e : map.get(e);
        EventData b = (a == e) ? map.get(e) : e;
        if (a == null || b == null) {
            return Stream.empty();
        } else {
            return Stream.of(new Edge(a, b));
        }
    }
}
