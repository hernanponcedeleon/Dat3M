package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.constraints;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.MaterializedSubgraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.PathAlgorithm;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.google.common.collect.Sets;

import java.util.*;
import java.util.stream.Stream;

public class AcyclicityConstraint extends Constraint {

    private final List<Set<EventData>> violatingSccs = new ArrayList<>();
    private final Set<EventData> markedNodes = new HashSet<>();
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
        for (Set<EventData> scc : violatingSccs) {
            //Predicate<Edge> filter = (edge -> scc.contains(edge.getFirst()) && scc.contains(edge.getSecond()));
            MaterializedSubgraph subgraph = new MaterializedSubgraph(constrainedGraph, scc);
            Set<EventData> nodes = new HashSet<>(Sets.intersection(scc, markedNodes));
            while (!nodes.isEmpty()) {
                EventData e = nodes.stream().findAny().get();
                List<Edge> cycle = PathAlgorithm.findShortestPath(subgraph, e, e);
                //List<Edge> cycle = PathAlgorithm.findShortestPath(constrainedGraph, e, e, filter);
                cycle.forEach(edge -> nodes.remove(edge.getFirst()));
                cycles.add(cycle);
            }
        }
        return cycles;
    }

    @Override
    public void onGraphChanged(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        addedEdges.forEach(e -> markedNodes.add(e.getFirst()));
    }

    @Override
    public void backtrackTo(int time) {
        violatingSccs.clear();
        markedNodes.clear();
    }

    @Override
    public void initialize(ExecutionModel context) {
        super.initialize(context);
        violatingSccs.clear();
        markedNodes.clear();
        nodeMap = new EventNode[context.getEventList().size()];
        for (EventData e : context.getEventList()) {
            nodeMap[e.getId()] = new EventNode(e);
        }
        onGraphChanged(constrainedGraph, constrainedGraph.setView());
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

    private void strongConnect(EventNode v) {
        v.index = index;
        v.lowlink = index;
        stack.push(v);
        v.isOnStack = true;
        index++;

        for (Edge e : constrainedGraph.outEdges(v.event)) {
            EventNode w = nodeMap[e.getSecond().getId()];

            //v.successorStream().forEach(w -> {
                if (!w.wasVisited()) {
                    strongConnect(w);
                    v.lowlink = Math.min(v.lowlink, w.lowlink);
                } else if (w.isOnStack) {
                    v.lowlink = Math.min(v.lowlink, w.index);
                }

                if (w == v) {
                    v.hasSelfLoop = true;
                }
            //});
        }


        if (v.lowlink == v.index) {
            Set<EventData> scc = new HashSet<>();
            EventNode w;
            do {
                w = stack.pop();
                w.isOnStack = false;
                scc.add(w.event);
            } while (w != v);

            if (v.hasSelfLoop || scc.size() > 1) {
                violatingSccs.add(scc);
            }
        }
    }

    private class EventNode {
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

        public Stream<EventNode> successorStream() {
            final EventNode[] nodeMap = AcyclicityConstraint.this.nodeMap;
            return constrainedGraph.outEdgeStream(event).map(e -> nodeMap[e.getSecond().getId()]);
        }


        public void reset() {
            hasSelfLoop = false;
            isOnStack = false;
            index = -1;
            lowlink = -1;
        }
    }
}