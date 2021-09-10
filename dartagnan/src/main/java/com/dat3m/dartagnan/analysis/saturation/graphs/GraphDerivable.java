package com.dat3m.dartagnan.analysis.saturation.graphs;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.utils.dependable.Dependent;

import java.util.Collection;

public interface GraphDerivable extends Dependent<RelationGraph> {

    Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges);
    void backtrack();
}
