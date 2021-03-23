package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.program.arch.aarch64.utils.EType;
import com.dat3m.dartagnan.program.event.rmw.RMWStore;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.wmm.filter.FilterAbstract;
import com.dat3m.dartagnan.wmm.filter.FilterBasic;
import com.dat3m.dartagnan.wmm.filter.FilterIntersection;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;

import java.util.Iterator;
import java.util.List;

public class RMWGraph extends StaticEventGraph {


    private static final FilterAbstract loadExclFilter  = FilterIntersection.get(
            FilterBasic.get(EType.EXCL),
            FilterBasic.get(EType.READ)
    );

    private static final FilterAbstract storeExclFilter = FilterIntersection.get(
            FilterBasic.get(EType.EXCL),
            FilterBasic.get(EType.WRITE)
    );

    // Filters for the initial load of a lock event (which consists of Load->CondJump->Write)
    private static final FilterAbstract lockFilter = FilterIntersection.get(FilterIntersection.get(
            FilterBasic.get(EType.LOCK),
            FilterBasic.get(EType.RMW)),
            FilterBasic.get(EType.READ)
    );

    private static final FilterAbstract rmwFilter = FilterIntersection.get(
            FilterBasic.get(EType.RMW),
            FilterBasic.get(EType.WRITE)
    );


    private final SimpleGraph graph;

    public RMWGraph() {
        graph = new SimpleGraph();
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        graph.constructFromModel(context);

        populate();
        this.size = graph.getEstimatedSize();
    }


    /* There are three cases where the RMW-Relation is established:
     (1) LOCK : Load -> CondJump -> Store
     (2) RMW : RMWLoad -> RMWStore (completely static)
     (3) ExclAccess : ExclLoad -> ExclStore (dependent on control flow)
    */
    private void populate() {
        //TODO: We still need to encode parts of RMW to give correct semantics to exclusive Load/Store on AARCH64
        for (List<EventData> events : context.getThreadEventsMap().values()) {
            EventData lastExclLoad = null;
            for (int i = 0; i < events.size(); i++) {
                EventData e = events.get(i);
                if (e.isRead()) {
                    if (e.isLock()) {   // Locks ~ (Load -> CondJump -> Store)
                        if (i + 1 < events.size()) {
                            // The condition fails, if the lock was not obtained
                            EventData next = events.get(i + 1);
                            graph.add(new Edge(e, next));
                        }
                        //EventData nnext = events.get(i + 2); (The CondJump is not visible)

                    } else if (e.isExclusive()) {  // LoadExcl
                        lastExclLoad = e;
                    }
                } else if (e.isWrite()) {
                    if (e.isExclusive()) { // StoreExcl
                        if (lastExclLoad == null) {
                            throw new IllegalStateException("Exclusive store was executed without exclusive load.");
                        }
                        graph.add(new Edge(lastExclLoad, e));
                        lastExclLoad = null;
                    } else if (e.getEvent() instanceof RMWStore) { // RMWStore
                        EventData load = context.getData(((RMWStore) e.getEvent()).getLoadEvent());
                        graph.add(new Edge(load, e));
                    }
                }
            }
        }
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return graph.contains(a, b);
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return graph.getMinSize(e, dir);
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return graph.edgeIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return graph.edgeIterator(e, dir);
    }
}
