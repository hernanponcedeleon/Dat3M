package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;


import java.util.Iterator;
import java.util.Map;
import java.util.Set;

//TODO: This is considered purely static right now (reason computation is static)
public abstract class DepGraph extends StaticEventGraph {
    protected final SimpleGraph graph;

    public DepGraph() {
        graph = new SimpleGraph();
    }

    protected abstract Map<EventData, Set<EventData>> getDependencyMap();

    @Override
    public boolean contains(Edge edge) {
        return graph.contains(edge);
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

    @Override
    public boolean contains(EventData a, EventData b) {
        return graph.contains(a, b);
    }


    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        graph.constructFromModel(context);

        Map<EventData, Set<EventData>> depMap = getDependencyMap();
        for (EventData e1: depMap.keySet()) {
            for (EventData e2 : depMap.get(e1)) {
                graph.add(new Edge(e2, e1));
            }
        }

        size = graph.size();
    }
}
