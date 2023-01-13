package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import org.sosy_lab.java_smt.api.Model;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
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
            k.getMaySet()
                    .stream().map(t -> this.getEdgeFromTuple(t, m, edge)).filter(Objects::nonNull)
                    .forEach(simpleGraph::add);
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

    private Edge getEdgeFromTuple(Tuple t, Model m, EncodingContext.EdgeEncoder edge) {
        Optional<EventData> e1 = model.getData(t.getFirst());
        Optional<EventData> e2 = model.getData(t.getSecond());
        return e1.isPresent() && e2.isPresent() ? getEdgeFromEventData(e1.get(), e2.get(), m, edge) : null;
    }
}