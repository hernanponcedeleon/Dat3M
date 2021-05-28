package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public  class AddrDepGraph extends DepGraph {

    @Override
    protected Map<EventData, Set<EventData>> getDependencyMap() {
        return context.getAddrDepMap();
    }
}
