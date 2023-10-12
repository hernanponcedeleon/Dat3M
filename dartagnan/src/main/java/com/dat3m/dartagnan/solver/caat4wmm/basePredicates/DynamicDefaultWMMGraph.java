package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import org.sosy_lab.java_smt.api.Model;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

// A default implementation for any encoded relation, e.g. base relations or non-base but cut relations.
public class DynamicDefaultWMMGraph extends MaterializedWMMGraph {
    private final String name;

    public DynamicDefaultWMMGraph(String n) {
        name = n;
    }

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public void repopulate() {
        // Careful: The wrapped model <getModel> might get closed/disposed while ExecutionModel as a whole is
        // still in use. The caller should make sure that the underlying model is still alive right now.
        Model m = model.getModel();
        EncodingContext ctx = model.getContext();
        Relation relation = ctx.getTask().getMemoryModel().getRelation(name);
        EncodingContext.EdgeEncoder edge = ctx.edge(relation);
        RelationAnalysis ra = ctx.getAnalysisContext().get(RelationAnalysis.class);
        RelationAnalysis.Knowledge k = ra.getKnowledge(relation);
        if (k.getMaySet().size() < domain.size() * domain.size()) {
            k.getMaySet().apply((e1, e2) -> {
                Optional<EventData> d1 = model.getData(e1);
                Optional<EventData> d2 = model.getData(e2);
                if (d1.isPresent() && d2.isPresent()) {
                    simpleGraph.add(getEdgeFromEventData(d1.get(), d2.get(), m, edge));
                }
            });
        } else {
            for (EventData e1 : model.getEventList()) {
                for (EventData e2 : model.getEventList()) {
                    Edge e = getEdgeFromEventData(e1, e2, m, edge);
                    if (e != null) {
                        simpleGraph.add(e);
                    }
                }
            }
        }
    }

    private Edge getEdgeFromEventData(EventData e1, EventData e2, Model m, EncodingContext.EdgeEncoder edge) {
        return m.evaluate(edge.encode(e1.getEvent(), e2.getEvent())) == Boolean.TRUE
                ? new Edge(e1.getId(), e2.getId()) : null;
    }
}