package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.Collections;
import java.util.List;
import java.util.Objects;

// Used for static relations that are not yet implemented explicitly
public class StaticDefaultEventGraph extends MaterializedGraph {
    private final Relation relation;

    public StaticDefaultEventGraph(Relation rel) {
        this.relation = rel;
    }

    @Override
    public List<? extends EventGraph> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitBase(this, data, context);
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        relation.getMaxTupleSet().stream()
                .map(model::getEdge)
                .filter(Objects::nonNull)
                .forEach(simpleGraph::add);
    }
}
