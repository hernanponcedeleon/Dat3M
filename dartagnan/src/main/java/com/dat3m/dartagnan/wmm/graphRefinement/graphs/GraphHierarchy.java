package com.dat3m.dartagnan.wmm.graphRefinement.graphs;

import com.dat3m.dartagnan.wmm.graphRefinement.ModelContext;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.dependable.DependencyGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.GraphListener;


import java.util.*;

//TODO: Maybe add a concrete way of backtracking

// This class should manage a hierarchy of event graphs such that the following operations are supported:
// (1) Adding edges and propagating changes
// (2) Backtracking to a previous state
// (3) Listening to changes in graphs

public class GraphHierarchy {
    private final Map<EventGraph, Set<GraphListener>> graphListenersMap;
    private DependencyGraph<EventGraph> dependencyGraph;
    private boolean changed = true;


    // Note: Whenever the dependency graph gets recomputed due to added/removed event graphs
    // the topological ordering may change non-deterministically.
    public DependencyGraph<EventGraph> getDependencyGraph() {
        if (changed) {
            dependencyGraph = DependencyGraph.from(graphListenersMap.keySet());
            // This makes sure that dependencies get added properly
            // if they were not added previously (i.e. if a graph was added but not its dependencies)
            dependencyGraph.getNodeContents().forEach(this::addEventGraph);
        }
        return dependencyGraph;
    }

    public Set<EventGraph> getGraphs() { return graphListenersMap.keySet(); }

    // The list of graphs in topological order
    public List<EventGraph> getGraphList() { return getDependencyGraph().getNodeContents(); }

    public EventGraph getRootGraph() { return getGraphList().get(0); }

    public GraphHierarchy() {
        graphListenersMap = new HashMap<>();
    }


    // Should only ever be used on non-derived Graphs
    public void addEdgesToGraph(EventGraph graph, Collection<Edge> edges) {
        if (!graph.isStatic()) {
            throw new UnsupportedOperationException("Edges can only be added directly to non-derived graphs!");
        }
        createPropagationTask(null, graph, edges, 0);
        forwardPropagate();
    }

    public void createPropagationTask(EventGraph from, EventGraph target, Collection<Edge> added, int priority) {
        if (target == null || added.isEmpty())
            return;
        tasks.add(new Task(from, target, added, priority));
    }

    public void initializeFromModel(ModelContext modelContext) {
        // Initializes in topological order!
        getGraphList().forEach(x -> x.initialize(modelContext));
    }

    public boolean addEventGraph(EventGraph graph) {
        boolean added = graphListenersMap.putIfAbsent(graph, new HashSet<>()) == null;
        changed |= added;
        return added;
    }

    public boolean removeEventGraph(EventGraph graph) {
        boolean removed = graphListenersMap.remove(graph) != null;
        changed |= removed;
        return removed;
    }

    public boolean addGraphListener(EventGraph graph, GraphListener listener) {
        if (!graphListenersMap.containsKey(graph)) {
            return false;
        }
        return graphListenersMap.get(graph).add(listener);
    }

    public boolean removeGraphListener(EventGraph graph, GraphListener listener) {
        if (!graphListenersMap.containsKey(graph)) {
            return false;
        }
        return graphListenersMap.get(graph).remove(listener);
    }

    public boolean removeGraphListener(GraphListener listener) {
        boolean changed = false;
        for (Set<GraphListener> listeners : graphListenersMap.values()) {
            changed |= listeners.remove(listener);
        }
        return changed;
    }


    public void backtrack() {
        //TODO: Let EventGraph.update return a boolean that indicates if the graph changed
        // Only then backtrack on the listeners
        // (We could even propagate the deleted edges, if the Graph was explicit)
        graphListenersMap.keySet().forEach(EventGraph::backtrack);
        graphListenersMap.values().stream().flatMap(Collection::stream).forEach(GraphListener::backtrack);
    }

    public void clearListeners() {
        graphListenersMap.values().forEach(Set::clear);
    }

    public void clear() {
        graphListenersMap.clear();
    }


    // ================= Propagation ===================

    private final PriorityQueue<Task> tasks = new PriorityQueue<>();
    private void forwardPropagate() {
        while (!tasks.isEmpty())
            tasks.poll().perform();
    }

    private class Task implements Comparable<Task> {
        private final EventGraph from;
        private final EventGraph target;
        private final Collection<Edge> added;
        private final int priority;

        public Task(EventGraph from, EventGraph target, Collection<Edge> added, int priority) {
            this.from = from;
            this.target = target;
            this.added = added;
            this.priority = priority;
        }

        @Override
        public int compareTo(Task o) {
            return this.priority - o.priority;
        }

        public void perform() {
            Collection<Edge> newEdges = target.forwardPropagate(from, added);
            if (newEdges.isEmpty())
                return;

            for (GraphListener listener : graphListenersMap.get(target)) {
                listener.onGraphChanged(target, newEdges);
            }

            List<DependencyGraph<EventGraph>.Node> dependents = dependencyGraph.get(target).getDependents();
            for (int i = 0; i < dependents.size() ; i++) {
                Task newTask = new Task(target, dependents.get(i).getContent(), newEdges, dependents.get(i).getTopologicalIndex());
                tasks.add(newTask);
                if (i < dependents.size() - 1)
                    newEdges = new HashSet<>(newEdges); // Copy collection for future iteration
            }

            /*for (DependencyGraph<EventGraph>.Node dependent : dependencyGraph.get(target).getDependents()) {
                Task newTask = new Task(target, dependent.getContent(), newEdges, dependent.getTopologicalIndex());
                tasks.add(newTask);
            }*/
        }
    }
}
