package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Collections;
import java.util.List;

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
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        TupleSet maxTupleSet = relation.getMaxTupleSet();
        for (Tuple tuple : maxTupleSet) {
            Edge e = context.getEdge(tuple);
            if (e != null) {
                simpleGraph.add(e);
            }
        }
    }
}
