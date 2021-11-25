package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs;

import java.util.Collection;

public interface GraphListener {
    void onGraphChanged(RelationGraph graph, Collection<Edge> addedEdges);
    void backtrackTo(int time);
}
