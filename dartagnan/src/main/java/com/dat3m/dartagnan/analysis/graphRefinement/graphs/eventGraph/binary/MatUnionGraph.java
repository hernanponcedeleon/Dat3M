package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.List;

// A materialized Union Graph. This seems to be more efficient than the virtualized UnionGraph
public class MatUnionGraph extends MaterializedGraph {

    private final EventGraph first;
    private final EventGraph second;

    @Override
    public List<? extends EventGraph> getDependencies() {
        return List.of(first, second);
    }

    public MatUnionGraph(EventGraph first, EventGraph second) {
        this.first = first;
        this.second = second;
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);

        simpleGraph.addAll(first.setView());
        simpleGraph.addAll(second.setView());
    }


    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == first || changedGraph == second) {
            addedEdges.removeIf(edge -> !simpleGraph.add(edge));
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitUnion(this, data, context);
    }


}