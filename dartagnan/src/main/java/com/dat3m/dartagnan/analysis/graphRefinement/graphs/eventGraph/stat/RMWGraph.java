package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.List;

public class RMWGraph extends MaterializedGraph {

    public RMWGraph() { }

    @Override
    public List<? extends EventGraph> getDependencies() {
        return List.of();
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        populate();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitBase(this, data, context);
    }


    /* There are four cases where the RMW-Relation is established:
     (1) LOCK : Load -> CondJump -> Store
     (2) RMW : RMWLoad -> RMWStore (completely static)
     (3) ExclAccess : ExclLoad -> ExclStore (dependent on control flow)
     (4) Atomic blocks: BeginAtomic -> Events* -> EndAtomic
    */
    private void populate() {
        // Atomic blocks
        model.getAtomicBlocksMap().values().stream().flatMap(Collection::stream).forEach(
                block -> {
                    for (int i = 0; i < block.size(); i++) {
                        for (int j = i + 1; j < block.size(); j++) {
                            simpleGraph.add(new Edge(block.get(i), block.get(j)));
                        }
                    }
                }
        );

        //TODO: We still need to encode parts of RMW to give correct semantics to exclusive Load/Store on AARCH64 (do we?)
        for (List<EventData> events : model.getThreadEventsMap().values()) {
            EventData lastExclLoad = null;
            for (int i = 0; i < events.size(); i++) {
                EventData e = events.get(i);
                if (e.isRead()) {
                    if (e.isLock()) {   // Locks ~ (Load -> CondJump -> Store)
                        if (i + 1 < events.size()) {
                            // The condition fails, if the lock was not obtained
                            EventData next = events.get(i + 1);
                            simpleGraph.add(new Edge(e, next));
                        }
                    } else if (e.isExclusive()) {  // LoadExcl
                        lastExclLoad = e;
                    }
                } else if (e.isWrite()) {
                    if (e.isExclusive()) { // StoreExcl
                        if (lastExclLoad == null) {
                            throw new IllegalStateException("Exclusive store was executed without exclusive load.");
                        }
                        simpleGraph.add(new Edge(lastExclLoad, e));
                        lastExclLoad = null;
                    } else if (e.getEvent() instanceof RMWStore) { // RMWStore
                        EventData load = model.getData(((RMWStore) e.getEvent()).getLoadEvent());
                        simpleGraph.add(new Edge(load, e));
                    }
                }
            }
        }
    }
}
