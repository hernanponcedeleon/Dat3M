package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.program.event.core.rmw.RMWStore;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.List;

public class RMWGraph extends MaterializedWMMGraph {

    public RMWGraph() { }

    /* Right now there are four cases where the RMW-Relation is established:
     (1) LOCK : Load -> CondJump -> Store
     (2) RMW : RMWLoad -> RMWStore (completely static)
     (3) ExclAccess : ExclLoad -> ExclStore (dependent on control flow)
     (4) Atomic blocks: BeginAtomic -> Events* -> EndAtomic

     We need to keep this in line with the implementation of RelRMW!
    */
    @Override
    public void repopulate() {
        // Atomic blocks
        model.getAtomicBlocksMap().values().stream().flatMap(Collection::stream).forEach(
                block -> {
                    for (int i = 0; i < block.size(); i++) {
                        for (int j = i + 1; j < block.size(); j++) {
                            simpleGraph.add(new Edge(block.get(i).getId(), block.get(j).getId()));
                        }
                    }
                }
        );

        for (List<EventData> events : model.getThreadEventsMap().values()) {
            EventData lastExclLoad = null;
            for (int i = 0; i < events.size(); i++) {
                EventData e = events.get(i);
                if (e.isRead()) {
                    if (e.isLock()) {   // Locks ~ (Load -> CondJump -> Store)
                        if (i + 1 < events.size()) {
                            // The condition fails, if the lock was not obtained cause then
                            // it will be the last event of the thread (we terminate on failed locks)
                            EventData next = events.get(i + 1);
                            simpleGraph.add(new Edge(e.getId(), next.getId()));
                        }
                    } else if (e.isExclusive()) {  // LoadExcl
                        lastExclLoad = e;
                    }
                } else if (e.isWrite()) {
                    if (e.isExclusive()) { // StoreExcl
                        if (lastExclLoad == null) {
                            throw new IllegalStateException("Exclusive store was executed without preceding exclusive load.");
                        }
                        simpleGraph.add(new Edge(lastExclLoad.getId(), e.getId()));
                        lastExclLoad = null;
                    } else if (e.getEvent() instanceof RMWStore) { // RMWStore
                        EventData load = model.getData(((RMWStore) e.getEvent()).getLoadEvent()).get();
                        simpleGraph.add(new Edge(load.getId(), e.getId()));
                    }
                }
            }
        }
    }
}
