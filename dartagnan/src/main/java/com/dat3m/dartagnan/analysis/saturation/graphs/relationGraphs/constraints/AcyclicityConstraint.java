package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.constraints;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.MaterializedSubgraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.PathAlgorithm;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.collections.CollectionPool;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.collections.EventSet;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.google.common.collect.Sets;

import java.util.*;
import java.util.stream.Stream;

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
        for (Set<EventData> scc : violatingSccs) {
            MaterializedSubgraph subgraph = new MaterializedSubgraph(constrainedGraph, scc);
            Set<EventData> nodes = new HashSet<>(Sets.intersection(scc, markedNodes));
            while (!nodes.isEmpty()) {
                EventData e = nodes.stream().findAny().get();
                List<Edge> cycle = PathAlgorithm.findShortestPath(subgraph, e, e);
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

    // The TEMP_LIST is used to temporary hold the nodes in a SCC.
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