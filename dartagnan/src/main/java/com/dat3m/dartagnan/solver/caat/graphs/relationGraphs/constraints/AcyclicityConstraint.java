package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.constraints;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.MaterializedSubgraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.PathAlgorithm;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.collections.CollectionPool;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.collections.EventSet;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.google.common.collect.Sets;

import java.util.*;

public class AcyclicityConstraint extends Constraint {

    private static final CollectionPool<EventSet> EVENT_SET_COLLECTION_POOL =
            new CollectionPool<>(EventSet::new, 10);


    private final List<EventSet> violatingSccs = new ArrayList<>();
    private final EventSet markedNodes = new EventSet();
    private EventNode[] nodeMap;

    public AcyclicityConstraint(RelationGraph constrainedGraph) {
        super(constrainedGraph);
    }


    @Override
    public boolean checkForViolations() {
        if (!violatingSccs.isEmpty()) {
            return true;
        } else if (markedNodes.isEmpty()) {
            return false;
        }
        tarjan();
        violatingSccs.sort(Comparator.comparingInt(Set::size));
        if (violatingSccs.isEmpty()) {
            markedNodes.clear();
        }
        return !violatingSccs.isEmpty();
    }

    @Override
    public List<List<Edge>> getViolations() {
        if (violatingSccs.isEmpty()) {
            return Collections.emptyList();
        }

        List<List<Edge>> cycles = new ArrayList<>();
        // Current implementation: For all marked events <e> in all SCCs:
        // (1) find a shortest path C from <e> to <e> (=cycle)
        // (2) remove all nodes in C from the search space (those nodes are likely to give the same cycle)
        // (3) remove chords and normalize cycle order (starting from element with smallest id)
        for (Set<EventData> scc : violatingSccs) {
            MaterializedSubgraph subgraph = new MaterializedSubgraph(constrainedGraph, scc);
            Set<EventData> nodes = new HashSet<>(Sets.intersection(scc, markedNodes));
            while (!nodes.isEmpty()) {
                //TODO: Most cycles have chords, so a specialized algorithm that avoids
                // chords altogether would be great
                EventData e = nodes.stream().findAny().get();

                List<Edge> cycle = PathAlgorithm.findShortestPath(subgraph, e, e);
                cycle = new ArrayList<>(cycle);

                cycle.forEach(edge -> nodes.remove(edge.getFirst()));
                reduceChordsAndNormalize(cycle);
                if (!cycles.contains(cycle)) {
                    cycles.add(cycle);
                }
            }
        }

        return cycles;
    }

    private void reduceChordsAndNormalize(List<Edge> cycle) {
        // Reduce chords by iteratively merging first and last edge if possible
        // Note that edges in the middle should not have chords
        // since we start with a shortest cycle rooted at some node <e>
        boolean prog;
        do {
            if (cycle.size() == 1) {
                return;
            }
            prog = false;
            Edge in = cycle.get(cycle.size() - 1);
            Edge out = cycle.get(0);
            Edge chord = constrainedGraph.get(new Edge(in.getFirst(), out.getSecond())).orElse(null);
            if (chord != null) {
                cycle.remove(cycle.size() - 1);
                cycle.set(0, chord);
                prog = true;
            }
        } while (prog);

        // Normalize
        int first = 0;
        int minId = Integer.MAX_VALUE;
        int counter = 0;
        for (Edge e : cycle) {
            if (e.getFirst().getId() < minId) {
                minId = e.getFirst().getId();
                first = counter;
            }
            counter++;
        }
        Collections.rotate(cycle, -first);
    }

    @Override
    public void onGraphChanged(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        addedEdges.forEach(e -> markedNodes.add(e.getFirst()));
    }

    @Override
    public void backtrackTo(int time) {
        cleanUp();
    }

    @Override
    public void initialize(ExecutionModel model) {
        super.initialize(model);
        cleanUp();
        markedNodes.ensureCapacity(model.getEventList().size());
        nodeMap = new EventNode[model.getEventList().size()];
        for (EventData e : model.getEventList()) {
            nodeMap[e.getId()] = new EventNode(e);
        }
        onGraphChanged(constrainedGraph, constrainedGraph.setView());
    }

    private void cleanUp() {
        violatingSccs.forEach(EVENT_SET_COLLECTION_POOL::returnToPool);
        violatingSccs.clear();
        markedNodes.clear();
    }


    // ============== Tarjan & SCCs ================

    private final Deque<EventNode> stack = new ArrayDeque<>();
    private int index = 0;
    private void tarjan() {
        index = 0;
        stack.clear();

        for (EventNode node : nodeMap) {
            node.reset();
        }

        for (EventNode node : nodeMap) {
            if (!node.wasVisited()) {
                strongConnect(node);
            }
        }
    }

    // The TEMP_LIST is used to temporary hold the nodes in an SCC.
    // The SCC will only actually get created if it is violating! (selfloop or size > 1)
    private static final ArrayList<EventData> TEMP_LIST = new ArrayList<>();
    private void strongConnect(EventNode v) {
        v.index = index;
        v.lowlink = index;
        stack.push(v);
        v.isOnStack = true;
        index++;

        for (Edge e : constrainedGraph.outEdges(v.event)) {
            EventNode w = nodeMap[e.getSecond().getId()];
            if (!w.wasVisited()) {
                strongConnect(w);
                v.lowlink = Math.min(v.lowlink, w.lowlink);
            } else if (w.isOnStack) {
                v.lowlink = Math.min(v.lowlink, w.index);
            }

            if (w == v) {
                v.hasSelfLoop = true;
            }
        }


        if (v.lowlink == v.index) {
            EventNode w;
            do {
                w = stack.pop();
                w.isOnStack = false;
                TEMP_LIST.add(w.event);
            } while (w != v);

            if (v.hasSelfLoop || TEMP_LIST.size() > 1) {
                EventSet scc = EVENT_SET_COLLECTION_POOL.get();
                scc.ensureCapacity(model.getEventList().size());
                scc.clear();
                scc.addAll(TEMP_LIST);
                violatingSccs.add(scc);
            }
            TEMP_LIST.clear();
        }
    }

    private static class EventNode {
        final EventData event;

        boolean hasSelfLoop = false;
        boolean isOnStack = false;
        int index = -1;
        int lowlink = -1;

        public EventNode(EventData event) {
            this.event = event;
        }

        boolean wasVisited() {
            return index != -1;
        }

        public void reset() {
            hasSelfLoop = false;
            isOnStack = false;
            index = -1;
            lowlink = -1;
        }

        @Override
        public String toString() {
            return event.toString();
        }
    }
}