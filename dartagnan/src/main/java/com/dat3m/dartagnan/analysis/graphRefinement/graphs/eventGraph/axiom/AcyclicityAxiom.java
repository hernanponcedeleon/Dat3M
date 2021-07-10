package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.OneTimeIterable;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MatSubgraph;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.google.common.collect.Iterators;
import com.google.common.collect.Sets;

import java.util.*;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.PathAlgorithm.findShortestPathBiDir;

public class AcyclicityAxiom extends GraphAxiom {

    private final List<Set<EventData>> violatingSccs = new ArrayList<>();
    private final Set<EventData> markedNodes = new HashSet<>();
    private EventNode[] nodeMap;

    public AcyclicityAxiom(EventGraph inner) {
        super(inner);
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
        if (violatingSccs.isEmpty())
            return Collections.emptyList();

        List<List<Edge>> cycles = new ArrayList<>();
        // Current implementation: For all marked events <e> in all SCCs, find a shortest cycle (e,e)
        for (Set<EventData> scc : violatingSccs) {
            MatSubgraph subgraph = new MatSubgraph(inner, scc);
            for (EventData e : Sets.intersection(scc, markedNodes)) {
                cycles.add(findShortestPathBiDir(subgraph, e, e));
            }
        }
        return cycles;
    }

    @Override
    public void onGraphChanged(EventGraph changedGraph, Collection<Edge> addedEdges) {
        addedEdges.forEach(e -> markedNodes.add(e.getFirst()));
    }

    @Override
    public void backtrack() {
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
        onGraphChanged(inner, inner.setView());
    }


    // ============== Tarjan & SCCs ================

    private final Stack<EventNode> stack = new Stack<>();
    private int index = 0;
    private void tarjan() {
        index = 0;
        stack.clear();

        for (EventNode node : nodeMap)
            node.reset();

        for (EventNode node : nodeMap) {
            if (!node.wasVisited())
                strongConnect(node);
        }
    }

    private void strongConnect(EventNode v) {
        v.index = index;
        v.lowlink = index;
        stack.push(v);
        v.isOnStack = true;
        index++;


        v.successorStream().forEach(w -> {
                if (!w.wasVisited()) {
                    strongConnect(w);
                    v.lowlink = Math.min(v.lowlink, w.lowlink);
                } else if (w.isOnStack) {
                    v.lowlink = Math.min(v.lowlink, w.index);
                }

                if (w == v) {
                    v.hasSelfLoop = true;
                }
        });


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
            return inner.outEdgeStream(event).map(e -> nodeMap[e.getSecond().getId()]);
        }

        public Iterable<EventNode> getSuccessors() {
            return OneTimeIterable.create(Iterators.transform(inner.outEdgeIterator(event), x -> nodeMap[x.getSecond().getId()]));
        }

        public void reset() {
            hasSelfLoop = false;
            isOnStack = false;
            index = -1;
            lowlink = -1;
        }
    }
}