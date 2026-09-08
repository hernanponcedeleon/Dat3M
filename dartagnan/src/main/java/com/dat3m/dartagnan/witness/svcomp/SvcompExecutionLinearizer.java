package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.RelationModel;
import com.dat3m.dartagnan.verification.model.event.EventModel;
import com.google.common.base.Verify;

import java.util.*;

import static com.dat3m.dartagnan.wmm.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.RF;

/**
 * Chooses a deterministic sequentially-consistent interleaving for an execution produced with {@code svcomp.cat}.
 */
final class SvcompExecutionLinearizer {

    private SvcompExecutionLinearizer() { }

    static List<EventModel> linearize(ExecutionModelNext model) {
        final Set<EventModel> events = new HashSet<>(model.getEventModels());
        final Map<EventModel, Set<EventModel>> successors = new HashMap<>();
        events.forEach(event -> successors.put(event, new HashSet<>()));

        // Add program-order (po) edges between consecutive events of each thread.
        for (var thread : model.getThreadModels()) {
            final List<EventModel> threadEvents = thread.getEventModels();
            for (int i = 1; i < threadEvents.size(); i++) {
                addEdge(successors, threadEvents.get(i - 1), threadEvents.get(i));
            }
        }

        final Set<RelationModel.EdgeModel> coherence = relationEdges(model, CO);
        for (RelationModel.EdgeModel edge : coherence) {
            addEdge(successors, edge.from(), edge.to());
        }
        for (RelationModel.EdgeModel readFrom : relationEdges(model, RF)) {
            addEdge(successors, readFrom.from(), readFrom.to());
            for (RelationModel.EdgeModel co : coherence) {
                if (co.from().equals(readFrom.from())) {
                    // fr = rf^-1 ; co
                    addEdge(successors, readFrom.to(), co.to());
                }
            }
        }

        // TODO: Extract this deterministic, cycle-rejecting topological sort into a general utility.
        // Use Kahn's algorithm to construct a topological ordering. The in-degree records how many
        // predecessors of each event still need to be added to the result.
        final Map<EventModel, Integer> inDegree = new HashMap<>();
        events.forEach(event -> inDegree.put(event, 0));
        for (Set<EventModel> targets : successors.values()) {
            targets.forEach(target -> adjustInDegree(inDegree, target, 1));
        }

        // Events without remaining predecessors are ready. Ordering them by ID makes the result deterministic.
        final Queue<EventModel> ready = new PriorityQueue<>(Comparator.comparingInt(EventModel::getId));
        inDegree.forEach((event, degree) -> {
            if (degree == 0) {
                ready.add(event);
            }
        });

        final List<EventModel> result = new ArrayList<>(events.size());
        while (!ready.isEmpty()) {
            final EventModel event = ready.remove();
            result.add(event);
            // Conceptually remove the selected event's outgoing edges and enqueue newly ready successors.
            for (EventModel successor : successors.get(event)) {
                if (adjustInDegree(inDegree, successor, -1) == 0) {
                    ready.add(successor);
                }
            }
        }
        Verify.verify(result.size() == events.size(), "svcomp.cat produced a non-SC execution");
        return result;
    }

    private static Set<RelationModel.EdgeModel> relationEdges(ExecutionModelNext model, String name) {
        return model.getRelationModels().stream()
                .filter(relation -> relation.getRelation().hasName(name))
                .findFirst()
                .map(RelationModel::getEdgeModels)
                .orElse(Set.of());
    }

    private static void addEdge(Map<EventModel, Set<EventModel>> successors, EventModel from, EventModel to) {
        if (from != to) {
            successors.get(from).add(to);
        }
    }

    private static int adjustInDegree(Map<EventModel, Integer> inDegree, EventModel event, int adjustment) {
        final int degree = Verify.verifyNotNull(
                inDegree.get(event), "Execution graph contains an edge to an unknown event: %s", event);
        final int adjustedDegree = degree + adjustment;
        inDegree.put(event, adjustedDegree);
        return adjustedDegree;
    }
}
