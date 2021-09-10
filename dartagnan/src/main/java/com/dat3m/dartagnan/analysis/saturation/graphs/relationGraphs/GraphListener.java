package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs;

import com.dat3m.dartagnan.analysis.saturation.graphs.Edge;

import java.util.Collection;

public interface GraphListener {
    void onGraphChanged(RelationGraph graph, Collection<Edge> addedEdges);
    void backtrack();
}
