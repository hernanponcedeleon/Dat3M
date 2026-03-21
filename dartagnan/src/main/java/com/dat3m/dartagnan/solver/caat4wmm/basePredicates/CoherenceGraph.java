package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;


import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Collection;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;

public class CoherenceGraph extends MaterializedWMMGraph {

    @Override
    public void repopulate() {
        final EncodingContext ctx = model.getContext();
        final IREvaluator evaluator = model.getEvaluator();
        final EncodingContext.EdgeEncoder co = ctx.edge(ctx.getTask().getMemoryModel().getRelation(CO));

        for (Collection<EventData> writes : model.getAddressWritesMap().values()) {
            for (EventData w1 : writes) {
                for (EventData w2 : writes) {
                    if (evaluator.hasEdge(co, w1.getEvent(), w2.getEvent())) {
                        this.simpleGraph.add(new Edge(w1.getId(), w2.getId()));
                    }
                }
            }

        }
    }

}
