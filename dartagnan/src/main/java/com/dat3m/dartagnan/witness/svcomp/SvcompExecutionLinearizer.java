package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.RelationModel;
import com.dat3m.dartagnan.verification.model.event.EventModel;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.google.common.base.Verify;

import java.util.*;

/**
 * Chooses a sequentially-consistent interleaving for an execution produced with {@code svcomp.cat}.
 */
final class SvcompExecutionLinearizer {

    private static final String HB = "hb-consistency";

    private SvcompExecutionLinearizer() { }

    static List<EventModel> linearize(ExecutionModelNext model) {
        final RelationModel hb = Verify.verifyNotNull(model.getRelationModels().stream()
                .filter(relation -> relation.getRelation().hasName(HB))
                .findFirst()
                .orElse(null), "Execution model does not contain relation '%s'", HB);
        final Set<EventModel> events = new HashSet<>(model.getEventModels());
        Verify.verify(hb.getEdgeModels().stream().allMatch(edge ->
                        events.contains(edge.from()) && events.contains(edge.to())),
                "Execution graph contains an edge with an unknown event");
        Verify.verify(hb.getEdgeModels().stream().noneMatch(edge -> edge.from() == edge.to()),
                "svcomp.cat produced a non-SC execution");

        final Map<EventModel, Set<EventModel>> predecessors = new HashMap<>();
        events.forEach(event -> predecessors.put(event, new HashSet<>()));

        for (RelationModel.EdgeModel edge : hb.getEdgeModels()) {
            predecessors.get(edge.to()).add(edge.from());
        }

        final DependencyGraph<EventModel> dependencyGraph = DependencyGraph.from(events, predecessors);
        Verify.verify(dependencyGraph.getSCCs().size() == events.size(),
                "svcomp.cat produced a non-SC execution");
        return dependencyGraph.getNodeContents();
    }
}
