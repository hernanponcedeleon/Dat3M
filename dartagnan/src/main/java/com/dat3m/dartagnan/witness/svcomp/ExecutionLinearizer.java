package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.model.execution.Execution;
import com.dat3m.dartagnan.model.execution.ThreadExecution;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.threading.ThreadStart;
import com.dat3m.dartagnan.program.event.lang.svcomp.BeginAtomic;
import com.dat3m.dartagnan.program.event.lang.svcomp.EndAtomic;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
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

        final DependencyGraph<Event> dependencyGraph = DependencyGraph.from(events, predecessors);
        Verify.verify(dependencyGraph.getSCCs().size() == events.size(),
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
        final DependencyGraph<Event> groupGraph = DependencyGraph.from(groups.keySet(), groupPredecessors);
        Verify.verify(groupGraph.getSCCs().size() == groups.size(),
                "svcomp.cat produced an execution with incompatible atomic sections");
        return groupGraph.getNodeContents().stream().flatMap(group -> groups.get(group).stream()).toList();
    }
}
