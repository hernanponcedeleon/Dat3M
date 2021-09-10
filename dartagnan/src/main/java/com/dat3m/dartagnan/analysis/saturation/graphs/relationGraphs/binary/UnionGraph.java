package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.binary;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.saturation.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

// A materialized Union Graph.
// This seems to be more efficient than the virtualized UnionGraph we used before.
public class UnionGraph extends MaterializedGraph {

    private final RelationGraph first;
    private final RelationGraph second;

    @Override
    public List<? extends RelationGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    public RelationGraph getFirst() { return first; }
    public RelationGraph getSecond() { return second; }

    public UnionGraph(RelationGraph first, RelationGraph second) {
        this.first = first;
        this.second = second;
    }

    private Edge derive(Edge e) {
        return e.with(e.getDerivationLength() + 1);
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);

        //TODO: Maybe try to minimize the derivation length initially
        first.edgeStream().map(this::derive).forEach(simpleGraph::add);
        second.edgeStream().map(this::derive).forEach(simpleGraph::add);
    }


    @Override
    public Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == first || changedGraph == second) {
            return addedEdges.stream()
                    .map(this::derive)
                    .filter(simpleGraph::add).collect(Collectors.toList());
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitUnion(this, data, context);
    }


}