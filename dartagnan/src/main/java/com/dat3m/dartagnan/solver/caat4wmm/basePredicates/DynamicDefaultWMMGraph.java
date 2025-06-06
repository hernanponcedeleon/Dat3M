package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;

// A default implementation for any encoded relation, e.g. base relations or non-base but cut relations.
public class DynamicDefaultWMMGraph extends MaterializedWMMGraph {
    private final Relation relation;

    public DynamicDefaultWMMGraph(Relation rel) {
        this.relation = rel;
    }

    @Override
    public void repopulate() {
        // Careful: The wrapped model <getModel> might get closed/disposed while ExecutionModel as a whole is
        // still in use. The caller should make sure that the underlying model is still alive right now.
        final EncodingContext ctx = model.getContext();
        final IREvaluator m = new IREvaluator(ctx, model.getModel());
        final EncodingContext.EdgeEncoder edge = ctx.edge(relation);
        final RelationAnalysis.Knowledge k = ctx.getAnalysisContext().get(RelationAnalysis.class).getKnowledge(relation);

        if (k.getMaySet().size() < domain.size() * domain.size()) {
            k.getMaySet().apply((e1, e2) -> {
                final EventData d1 = model.getData(e1).orElse(null);
                final EventData d2 = model.getData(e2).orElse(null);
                if (d1 != null && d2 != null) {
                    final Edge e = getEdgeFromEventData(edge, d1, d2, m);
                    if (e != null) {
                        simpleGraph.add(e);
                    }
                }
            });
        } else {
            for (EventData e1 : model.getEventList()) {
                for (EventData e2 : model.getEventList()) {
                    final Edge e = getEdgeFromEventData(edge, e1, e2, m);
                    if (e != null) {
                        simpleGraph.add(e);
                    }
                }
            }
        }
    }

    private Edge getEdgeFromEventData(EncodingContext.EdgeEncoder edge, EventData e1, EventData e2, IREvaluator m) {
        return m.hasEdge(edge, e1.getEvent(), e2.getEvent()) ? new Edge(e1.getId(), e2.getId()) : null;
    }
}