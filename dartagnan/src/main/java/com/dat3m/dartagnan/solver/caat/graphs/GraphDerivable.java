package com.dat3m.dartagnan.solver.caat.graphs;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.utils.dependable.Dependent;

import java.util.Collection;

public interface GraphDerivable extends Dependent<RelationGraph> {

    // The input collection <addedEdges> SHALL never be modified!
    Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges);
    void backtrackTo(int time);
}
