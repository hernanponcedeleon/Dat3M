package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.basic;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

// A non-transitive version of coherence.
// In general, we define co as the transitive closure of this graph, i.e. co = sco+;
// This graph is not necessarily minimal, i.e. it is NOT a transitive reduction of co.
public class SimpleCoherenceGraph extends MaterializedGraph {

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.emptyList();
    }

    public SimpleCoherenceGraph() {
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        return forwardPropagate(addedEdges);
    }

    public Collection<Edge> forwardPropagate(Collection<Edge> addedEdges) {
        return addedEdges.stream().filter(simpleGraph::add).collect(Collectors.toList());
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitBase(this, data, context);
    }
}
