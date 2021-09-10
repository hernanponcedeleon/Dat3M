package com.dat3m.dartagnan.analysis.saturation.graphs;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.GraphListener;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.unary.RecursiveGraph;
import com.dat3m.dartagnan.utils.dependable.DependencyGraph;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.*;
import java.util.stream.Collectors;


// This class should manage a hierarchy of event graphs such that the following operations are supported:
// (1) Adding edges and propagating changes
// (2) Backtracking to a previous state
// (3) Listening to changes in graphs

public class GraphHierarchy {
    private final Map<RelationGraph, Set<GraphListener>> graphListenersMap;
    private final DependencyGraph<RelationGraph> dependencyGraph;
    private final PriorityQueue<Task> tasks = new PriorityQueue<>();

    // ============== Construction ===============

    public GraphHierarchy(Set<RelationGraph> relationGraphs) {
        dependencyGraph = DependencyGraph.from(relationGraphs);
        // The hashmap is created with a special load factor and capacity to avoid resizing.
        graphListenersMap = new HashMap<>(dependencyGraph.getNodeContents().size() * 4 / 3, 0.75f);
        dependencyGraph.getNodeContents().forEach(x -> graphListenersMap.put(x, new HashSet<>()));
    }

    // ========================================

    // ============= Accessors =================

    public Set<RelationGraph> getGraphs() { return graphListenersMap.keySet(); }

    // The list of graphs in topological order
    public List<RelationGraph> getGraphList() { return dependencyGraph.getNodeContents(); }

    public RelationGraph getRootGraph() { return getGraphList().get(0); }

    public DependencyGraph<RelationGraph> getDependencyGraph() {
        return dependencyGraph;
    }

    // ==========================================

    // ============== Initialization =============

    public void constructFromModel(ExecutionModel executionModel) {
        // Initializes in topological order!
        for (Set<DependencyGraph<RelationGraph>.Node> scc : dependencyGraph.getSCCs()) {
            Set<RelationGraph> recGrp = scc.stream().map(DependencyGraph.Node::getContent).collect(Collectors.toSet());
            if (recGrp.size() == 1) {
                recGrp.stream().findAny().get().constructFromModel(executionModel);
            } else {
                initRecursively(recGrp.stream().findAny().get(), executionModel, recGrp, new HashSet<>());

                // For all recursive relations, initialize the propagation
                //TODO: Maybe copy all recursive graphs into a new set and reuse that set
                recGrp.stream().filter(x -> x instanceof RecursiveGraph).forEach(x -> {
                    for(RelationGraph dep : x.getDependencies()) {
                        createPropagationTask(dep, x, new ArrayList<>(dep.setView()), 0);
                    }
                });

                // Propagate within this recursive group
                while (!tasks.isEmpty()) {
                    handleTask(tasks.poll(), true);
                }
            }
        }
    }

    // --------------------------------------------

    private void initRecursively(RelationGraph graph, ExecutionModel executionModel, Set<RelationGraph> recGroup, Set<RelationGraph> initialized) {
        if (initialized.contains(graph) || !recGroup.contains(graph)) {
            return;
        }
        if (graph instanceof RecursiveGraph) {
            graph.constructFromModel(executionModel);
            initialized.add(graph);
        }
        for (RelationGraph dep : graph.getDependencies()) {
            initRecursively(dep, executionModel, recGroup, initialized);
        }
        if (!initialized.contains(graph)) {
            graph.constructFromModel(executionModel);
            initialized.add(graph);
        }
    }

    // ==========================================

    // ============== Propagation ===============

    // Should only ever be used on non-derived Graphs
    public void addEdgesAndPropagate(RelationGraph graph, Collection<Edge> edges) {
        if (!graph.isStatic()) {
            throw new UnsupportedOperationException("Edges can only be added directly to non-derived graphs!");
        }
        createPropagationTask(null, graph, edges, 0);
        forwardPropagate();
    }

    public void backtrack() {
        graphListenersMap.keySet().forEach(RelationGraph::backtrack);
        graphListenersMap.values().stream().flatMap(Collection::stream).forEach(GraphListener::backtrack);
    }

    // --------------------------------------------

    private void forwardPropagate() {
        while (!tasks.isEmpty()) {
            handleTask(tasks.poll(), false);
        }
    }

    private void createPropagationTask(RelationGraph from, RelationGraph target, Collection<Edge> added, int priority) {
        if (target == null || added.isEmpty()) {
            return;
        }
        tasks.add(new Task(from, target, added, priority));
    }

    private void handleTask(Task task, boolean withinRecGroup) {
        RelationGraph target = task.target;
        RelationGraph from = task.from;
        Collection<Edge> added = task.added;

        Collection<Edge> newEdges = target.forwardPropagate(from, added);
        if (newEdges.isEmpty()) {
            // Nothing has changed, so we don't create new propagation tasks
            return;
        }

        for (GraphListener listener : graphListenersMap.get(target)) {
            listener.onGraphChanged(target, newEdges);
        }

        List<DependencyGraph<RelationGraph>.Node> dependents = dependencyGraph.get(target).getDependents();
        if (withinRecGroup) {
            // Limits propagation to EventGraphs in the same recursive Group.
            Set<DependencyGraph<RelationGraph>.Node> recGroup = dependencyGraph.get(target).getSCC();
            dependents = dependents.stream().filter(recGroup::contains).collect(Collectors.toList());
        }
        for (DependencyGraph<RelationGraph>.Node dependent : dependents) {
            Task newTask = new Task(target, dependent.getContent(), newEdges, dependent.getTopologicalIndex());
            tasks.add(newTask);
        }
    }

    // ==========================================

    // ============== Listeners =================

    public boolean addGraphListener(RelationGraph graph, GraphListener listener) {
        if (!graphListenersMap.containsKey(graph)) {
            return false;
        }
        return graphListenersMap.get(graph).add(listener);
    }

    public boolean removeGraphListener(RelationGraph graph, GraphListener listener) {
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


    public void clearListeners() {
        graphListenersMap.values().forEach(Set::clear);
    }

    // ================= Internal structures ===================


    private static class Task implements Comparable<Task> {
        private final RelationGraph from;
        private final RelationGraph target;
        private final Collection<Edge> added;
        private final int priority;

        public Task(RelationGraph from, RelationGraph target, Collection<Edge> added, int priority) {
            this.from = from;
            this.target = target;
            this.added = added;
            this.priority = priority;
        }

        @Override
        public int compareTo(Task o) {
            return this.priority - o.priority;
        }

    }

    // =======================================================
}
