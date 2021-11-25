package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.stat;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.MaterializedGraph;
import com.dat3m.dartagnan.solver.caat.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

// Used for static relations that are not yet implemented explicitly
public class StaticDefaultRelationGraph extends MaterializedGraph {
    private final Relation relation;

    public StaticDefaultRelationGraph(Relation rel) {
        this.relation = rel;
    }

    @Override
    public List<? extends RelationGraph> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitBase(this, data, context);
    }

    private Optional<Edge> getEdgeFromTuple(Tuple t) {
        Optional<EventData> e1 = model.getData(t.getFirst());
        Optional<EventData> e2 = model.getData(t.getSecond());
        return (e1.isPresent() && e2.isPresent()) ? Optional.of(new Edge(e1.get(), e2.get())) : Optional.empty();
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        relation.getMaxTupleSet().forEach(t -> getEdgeFromTuple(t).ifPresent(simpleGraph::add));
    }
}
