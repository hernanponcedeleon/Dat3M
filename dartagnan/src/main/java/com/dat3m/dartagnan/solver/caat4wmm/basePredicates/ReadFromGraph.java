package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;


import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;

public class ReadFromGraph extends MaterializedWMMGraph {
    @Override
    public void repopulate() {
        final EncodingContext ctx = model.getContext();
        final EncodingContext.EdgeEncoder rf = ctx.edge(ctx.getTask().getMemoryModel().getRelation(RF));
        final IREvaluator irModel = model.getEvaluator();

        for (Map.Entry<Object, Set<EventData>> addressedReads : model.getAddressReadsMap().entrySet()) {
            final Object address = addressedReads.getKey();
            for (EventData read : addressedReads.getValue()) {
                for (EventData write : model.getAddressWritesMap().get(address)) {
                    if (irModel.hasEdge(rf, write.getEvent(), read.getEvent())) {
                        this.simpleGraph.add(new Edge(write.getId(), read.getId()));
                        break;
                    }
                }
            }
        }
    }
}
