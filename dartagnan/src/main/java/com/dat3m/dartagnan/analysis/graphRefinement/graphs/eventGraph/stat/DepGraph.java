package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

//TODO: This is considered purely static right now (reason computation is static)
public abstract class DepGraph extends MaterializedGraph {

    public DepGraph() { }

    protected abstract Map<EventData, Set<EventData>> getDependencyMap();

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

        Map<EventData, Set<EventData>> depMap = getDependencyMap();
        for (EventData e1: depMap.keySet()) {
            depMap.get(e1).forEach(e2 -> simpleGraph.add(new Edge(e2, e1)));
        }
    }
}
