package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

// Used for static relations that are not yet implemented explicitly
public class StaticDefaultWMMGraph extends MaterializedWMMGraph {
    private final Relation relation;
    private final RelationAnalysis ra;

    public StaticDefaultWMMGraph(Relation rel, RelationAnalysis relationAnalysis) {
        this.relation = rel;
        this.ra = relationAnalysis;
    }

    @Override
    public List<RelationGraph> getDependencies() {
        return Collections.emptyList();
    }

    @Override
    public void repopulate() {
        ra.getKnowledge(relation).getMaySet()
                .stream().map(this::getEdgeFromTuple).filter(Objects::nonNull)
                .forEach(simpleGraph::add);
    }

    private Edge getEdgeFromTuple(Tuple t) {
        Optional<EventData> e1 = model.getData(t.getFirst());
        Optional<EventData> e2 = model.getData(t.getSecond());
        return (e1.isPresent() && e2.isPresent()) ? new Edge(e1.get().getId(), e2.get().getId()) : null;
    }
}
