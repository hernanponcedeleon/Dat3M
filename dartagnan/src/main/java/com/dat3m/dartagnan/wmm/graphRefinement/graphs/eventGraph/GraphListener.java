package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph;

import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;

import java.util.Collection;

public interface GraphListener {
    void onGraphChanged(EventGraph graph, Collection<Edge> addedEdges);
    void backtrack();
}
