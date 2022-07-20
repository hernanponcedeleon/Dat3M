package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;
import org.sosy_lab.java_smt.api.Model;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

// A default implementation for any encoded relation, e.g. base relations or non-base but cut relations.
public class DynamicDefaultWMMGraph extends MaterializedWMMGraph {
    private final Relation relation;

    public DynamicDefaultWMMGraph(Relation rel) {
        this.relation = rel;
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

        TupleSet may = model.getTask().getAnalysisContext().get(RelationAnalysis.class).may(relation);
        if(may.size() < domain.size() * domain.size()) {
            may
                    .stream().map(t -> this.getEdgeFromTuple(t, m)).filter(Objects::nonNull)
                    .forEach(simpleGraph::add);
        } else {
            for (EventData e1 : model.getEventList()) {
                for (EventData e2 : model.getEventList()) {
                    Edge e = getEdgeFromEventData(e1, e2, m);
                    if (e != null) {
                        simpleGraph.add(e);
                    }
                }
            }
        }
    }

    private Edge getEdgeFromEventData(EventData e1, EventData e2, Model m) {
        return m.evaluate(model.getTask().getWmmEncoder().edge(relation, e1.getEvent(), e2.getEvent())) == Boolean.TRUE
                ? new Edge(e1.getId(), e2.getId()) : null;
    }

    private Edge getEdgeFromTuple(Tuple t, Model m) {
        Optional<EventData> e1 = model.getData(t.getFirst());
        Optional<EventData> e2 = model.getData(t.getSecond());
        return e1.isPresent() && e2.isPresent() ? getEdgeFromEventData(e1.get(), e2.get(), m) : null;
    }
}