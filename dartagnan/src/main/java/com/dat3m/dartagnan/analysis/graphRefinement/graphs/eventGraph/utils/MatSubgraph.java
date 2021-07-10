package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class MatSubgraph extends MaterializedGraph {

    private final EventGraph sourceGraph;

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.singletonList(sourceGraph);
    }

    public MatSubgraph(EventGraph source, Collection<EventData> events) {
        sourceGraph = source;
        simpleGraph.constructFromModel(sourceGraph.getModel());

        for (EventData e : events) {
            sourceGraph.outEdgeStream(e).filter(edge -> events.contains(edge.getSecond())).forEach(simpleGraph::add);
        }

    }

    @Override
    public void backtrack() { }

}
