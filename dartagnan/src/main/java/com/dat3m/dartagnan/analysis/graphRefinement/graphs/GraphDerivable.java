package com.dat3m.dartagnan.analysis.graphRefinement.graphs;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.utils.dependable.Dependent;
import com.dat3m.dartagnan.verification.model.Edge;

import java.util.Collection;

public interface GraphDerivable extends Dependent<EventGraph> {

    Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges);
    void backtrack();
}
