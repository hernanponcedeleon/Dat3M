package com.dat3m.dartagnan.solver.newcaat4wmm.base;

import com.dat3m.dartagnan.solver.newcaat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.newcaat4wmm.MaterializedWMMGraph;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Map;
import java.util.Set;

public abstract class DepGraph extends MaterializedWMMGraph {

    public DepGraph() { }

    protected abstract Map<EventData, Set<EventData>> getDependencyMap();

    @Override
    public void repopulate() {

        Map<EventData, Set<EventData>> depMap = getDependencyMap();
        for (EventData e1 : depMap.keySet()) {
            depMap.get(e1).forEach(e2 -> simpleGraph.add(new Edge(e2.getId(), e1.getId())));
        }
    }
}
