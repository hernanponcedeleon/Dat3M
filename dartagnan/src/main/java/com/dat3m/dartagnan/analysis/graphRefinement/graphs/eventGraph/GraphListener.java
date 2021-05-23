package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph;

import com.dat3m.dartagnan.verification.model.Edge;

import java.util.Collection;

public interface GraphListener {
    void onGraphChanged(EventGraph graph, Collection<Edge> addedEdges);
    void backtrack();
}
