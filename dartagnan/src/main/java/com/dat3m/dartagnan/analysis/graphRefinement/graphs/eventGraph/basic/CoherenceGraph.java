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

//A non-transitive version of coherence.
// The fact that it is coherence is only relevant for <computeReason>
public class CoherenceGraph extends MaterializedGraph {

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.emptyList();
    }

    public CoherenceGraph() {
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
        //return addedEdges.stream().map(e -> e.with(100)).filter(simpleGraph::add).collect(Collectors.toList());
        return addedEdges.stream().filter(simpleGraph::add).collect(Collectors.toList());
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitBase(this, data, context);
    }
}
