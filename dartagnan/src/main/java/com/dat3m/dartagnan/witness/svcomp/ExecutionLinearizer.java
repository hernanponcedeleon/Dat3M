package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.model.ExecutionModelNext;
import com.dat3m.dartagnan.verification.model.RelationModel;
import com.dat3m.dartagnan.verification.model.RelationModel.EdgeModel;
import com.dat3m.dartagnan.verification.model.ThreadModel;
import com.dat3m.dartagnan.verification.model.event.EventModel;
import com.google.common.base.Verify;

import java.util.*;

/** Orders the events of an execution of {@code svcomp.cat} into a single interleaving. */
final class ExecutionLinearizer {

    private ExecutionLinearizer() { }

    /**
     * Orders all events consistently with {@code hb}, program order and thread creation.
     * The events of an atomic section stay contiguous.
     */
    static List<EventModel> linearize(ExecutionModelNext model, RelationModel hb) {
        final List<EventModel> events = model.getEventModels();
        final Map<EventModel, Set<EventModel>> predecessors = new HashMap<>();
        for (EdgeModel edge : hb.getEdgeModels()) {
            Verify.verify(edge.from() != edge.to(), "svcomp.cat produced a non-SC execution");
            predecessors.computeIfAbsent(edge.to(), _ -> new HashSet<>()).add(edge.from());
        }

        for (ThreadModel thread : model.getThreadModels()) {
            final List<EventModel> threadEvents = thread.getEventModels();
            for (int i = 1; i < threadEvents.size(); i++) {
                predecessors.computeIfAbsent(threadEvents.get(i), _ -> new HashSet<>())
                        .add(threadEvents.get(i - 1));
            }
            final ThreadStart start = thread.getThread().getEntry();
            if (start.isSpawned() && !threadEvents.isEmpty()) {
                final EventModel createEvent = model.getEventModelByEvent(start.getCreator());
                Verify.verify(createEvent != null, "Thread creator is not part of the execution model");
                predecessors.computeIfAbsent(threadEvents.getFirst(), _ -> new HashSet<>()).add(createEvent);
            }
        }

        final DependencyGraph<EventModel> dependencyGraph = DependencyGraph.from(events, predecessors);
        Verify.verify(dependencyGraph.getSCCs().size() == events.size(),
                "svcomp.cat produced a non-SC execution");

        final Map<EventModel, EventModel> groupForEvent = new HashMap<>();
        final Map<EventModel, List<EventModel>> groups = new LinkedHashMap<>();
        for (ThreadModel thread : model.getThreadModels()) {
            EventModel atomicBegin = null;
            for (EventModel event : thread.getEventModels()) {
                if (event.getEvent() instanceof BeginAtomic) {
                    atomicBegin = event;
                }
                final EventModel group = atomicBegin != null ? atomicBegin : event;
                groupForEvent.put(event, group);
                groups.computeIfAbsent(group, _ -> new ArrayList<>()).add(event);
                if (event.getEvent() instanceof EndAtomic) {
                    atomicBegin = null;
                }
            }
        }
        final Map<EventModel, Set<EventModel>> groupPredecessors = new HashMap<>();
        predecessors.forEach((event, dependencies) -> {
            final EventModel group = groupForEvent.get(event);
            for (EventModel dependency : dependencies) {
                final EventModel predecessor = groupForEvent.get(dependency);
                if (group != predecessor) {
                    groupPredecessors.computeIfAbsent(group, _ -> new HashSet<>()).add(predecessor);
                }
            }
        });
        final DependencyGraph<EventModel> groupGraph = DependencyGraph.from(groups.keySet(), groupPredecessors);
        Verify.verify(groupGraph.getSCCs().size() == groups.size(),
                "svcomp.cat produced an execution with incompatible atomic sections");
        return groupGraph.getNodeContents().stream().flatMap(group -> groups.get(group).stream()).toList();
    }
}
