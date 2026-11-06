package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.model.Execution;
import com.dat3m.dartagnan.model.ThreadExecution;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.base.Verify;

import java.util.*;

/** Orders the events of an execution of {@code svcomp.cat} into a single interleaving. */
final class ExecutionLinearizer {

    private ExecutionLinearizer() { }

    static List<Event> linearize(Execution execution, EventGraph hb) {
        final List<Event> events = execution.getEvents();
        final Map<Event, Set<Event>> predecessors = new HashMap<>();
        hb.apply((from, to) -> {
            Verify.verify(from != to, "svcomp.cat produced a non-SC execution");
            predecessors.computeIfAbsent(to, _ -> new HashSet<>()).add(from);
        });

        for (ThreadExecution thread : execution.getThreads()) {
            final List<Event> threadEvents = thread.getTrace();
            // hb only relates visible events, so asserts, thread creations, and atomic markers need these edges.
            for (int i = 1; i < threadEvents.size(); i++) {
                predecessors.computeIfAbsent(threadEvents.get(i), _ -> new HashSet<>())
                        .add(threadEvents.get(i - 1));
            }
            final ThreadStart start = thread.getThread().getEntry();
            if (start.isSpawned() && !threadEvents.isEmpty()) {
                Verify.verify(execution.isExecuted(start.getCreator()), "Thread creator is not part of the execution");
                predecessors.computeIfAbsent(threadEvents.getFirst(), _ -> new HashSet<>()).add(start.getCreator());
            }
        }

        Verify.verify(topologicalOrder(events, predecessors, execution).size() == events.size(),
                "svcomp.cat produced a non-SC execution");

        final Map<Event, Event> groupForEvent = new HashMap<>();
        final Map<Event, List<Event>> groups = new LinkedHashMap<>();
        for (ThreadExecution thread : execution.getThreads()) {
            Event atomicBegin = null;
            for (Event event : thread.getTrace()) {
                if (event instanceof BeginAtomic) {
                    atomicBegin = event;
                }
                final Event group = atomicBegin != null ? atomicBegin : event;
                groupForEvent.put(event, group);
                groups.computeIfAbsent(group, _ -> new ArrayList<>()).add(event);
                if (event instanceof EndAtomic) {
                    atomicBegin = null;
                }
            }
        }
        final Map<Event, Set<Event>> groupPredecessors = new HashMap<>();
        predecessors.forEach((event, dependencies) -> {
            final Event group = groupForEvent.get(event);
            for (Event dependency : dependencies) {
                final Event predecessor = groupForEvent.get(dependency);
                if (group != predecessor) {
                    groupPredecessors.computeIfAbsent(group, _ -> new HashSet<>()).add(predecessor);
                }
            }
        });
        final List<Event> groupOrder = topologicalOrder(groups.keySet(), groupPredecessors, execution);
        Verify.verify(groupOrder.size() == groups.size(),
                "svcomp.cat produced an execution with incompatible atomic sections");
        return groupOrder.stream().flatMap(group -> groups.get(group).stream()).toList();
    }

    // Ties are broken by event id, so the result is deterministic. Nodes on cycles are not part of the result.
    private static List<Event> topologicalOrder(Collection<Event> nodes, Map<Event, Set<Event>> predecessors,
            Execution execution) {
        final Map<Event, Integer> inDegree = new HashMap<>();
        final Map<Event, List<Event>> successors = new HashMap<>();
        for (Event node : nodes) {
            final Set<Event> dependencies = predecessors.getOrDefault(node, Set.of());
            inDegree.put(node, dependencies.size());
            dependencies.forEach(dependency -> successors.computeIfAbsent(dependency, _ -> new ArrayList<>()).add(node));
        }
        final PriorityQueue<Event> ready = new PriorityQueue<>(Comparator.comparingInt(execution::getId));
        inDegree.forEach((node, degree) -> {
            if (degree == 0) {
                ready.add(node);
            }
        });
        final List<Event> order = new ArrayList<>(nodes.size());
        while (!ready.isEmpty()) {
            final Event node = ready.poll();
            order.add(node);
            for (Event next : successors.getOrDefault(node, List.of())) {
                if (inDegree.merge(next, -1, Integer::sum) == 0) {
                    ready.add(next);
                }
            }
        }
        return order;
    }
}
