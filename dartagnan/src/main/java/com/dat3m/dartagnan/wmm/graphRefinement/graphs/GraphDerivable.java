package com.dat3m.dartagnan.wmm.graphRefinement.graphs;

import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.Dependent;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.EventGraph;

import java.util.Collection;

public interface GraphDerivable extends Dependent<EventGraph> {

    Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges);
}
