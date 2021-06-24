package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.ReasoningEngine;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.MatSubgraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.Subgraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.IteratorUtils;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.OneTimeIterable;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.DNF;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.SortedClauseSet;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.google.common.collect.Sets;

import java.util.*;

public class AcyclicityAxiom extends GraphAxiom {

    private final List<Set<EventData>> violatingSccs = new ArrayList<>();
    private EventNode[] nodeMap;
    private final Set<EventData> markedNodes = new HashSet<>();

    public AcyclicityAxiom(EventGraph inner) {
        super(inner);
    }

    @Override
    public void clearViolations() {
        violatingSccs.clear();
    }

    @Override
    public boolean checkForViolations() {
        if (markedNodes.isEmpty()) {
            return false;
        }
        tarjan();
        // Not sure if this is ok since usually total orderings are expected
        violatingSccs.sort(Comparator.comparingInt(Set::size));
        if (violatingSccs.isEmpty()) {
            markedNodes.clear();
        }
        return !violatingSccs.isEmpty();
    }

    @Override
    public DNF<CoreLiteral> computeReasons(ReasoningEngine reasEng) {
        // Perform (Bidirectional) BFS from all Events inside each SCC (NOTE: for now we do unidirectional BFS)
        if (violatingSccs.isEmpty())
            return DNF.FALSE;


        SortedClauseSet<CoreLiteral> clauseSet = new SortedClauseSet<>();
        // Current implementation: For all events <e> in all SCCs, find a shortest cycle (e,e)
        for (Set<EventData> scc : violatingSccs) {
            //Subgraph subgraph = new Subgraph(inner, scc);
            MatSubgraph subgraph = new MatSubgraph(inner, scc);
            //EventGraph subgraph = inner;

            for (EventData e : Sets.intersection(scc, markedNodes)) {
                Conjunction<CoreLiteral> conj = Conjunction.TRUE;
                for (Edge edge : subgraph.findShortestPathBiDir(e, e)) {
                    conj = conj.and(inner.computeReason(edge, reasEng));
                }
                clauseSet.add(conj);
            }
        }
        clauseSet.simplify();
        markedNodes.clear();
        return new DNF<>(clauseSet.getClauses());
    }

    @Override
    public Conjunction<CoreLiteral> computeSomeReason(ReasoningEngine reasEng) {
        // Finds a single cycle in the smallest SCC (not necessarily the smallest cycle tho)
        if (violatingSccs.isEmpty())
            return Conjunction.FALSE;

        Conjunction<CoreLiteral> res = Conjunction.TRUE;
        Set<EventData> scc = violatingSccs.get(0);
        Subgraph subgraph = new Subgraph(inner, scc);
        EventData e = scc.stream().findAny().get();
        for (Edge edge : subgraph.findShortestPath(e, e)) {
            res = res.and(inner.computeReason(edge, reasEng));
        }
        return res;
    }

    @Override
    public void onGraphChanged(EventGraph changedGraph, Collection<Edge> addedEdges) {
        //TODO: Maybe use information about added edges to make the acyclicity check (tarjan) faster?
        // Maybe call visit only on affected nodes?
        for (Edge e : addedEdges) {
            markedNodes.add(e.getFirst());
            markedNodes.add(e.getSecond());
        }
    }

    @Override
    public void backtrack() {
        violatingSccs.clear();
    }

    @Override
    public void initialize(ExecutionModel context) {
        super.initialize(context);
        markedNodes.clear();
        nodeMap = new EventNode[context.getEventList().size()];
        violatingSccs.clear();
        for (EventData e : context.getEventList()) {
            nodeMap[e.getId()] = new EventNode(e);
        }
        onGraphChanged(inner, inner);
    }



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

        for (EventNode w : v.getSuccessors()) {
            if (!w.wasVisited()) {
                strongConnect(w);
                v.lowlink = Math.min(v.lowlink, w.lowlink);
            }
            else if (w.isOnStack) {
                v.lowlink = Math.min(v.lowlink, w.index);
            }

            if (w == v) {
                v.hasSelfLoop = true;
            }
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
        EventData event;


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

        public Iterable<EventNode> getSuccessors() {
            return new OneTimeIterable<>(IteratorUtils.mappedIterator(inner.outEdgeIterator(event), x -> nodeMap[x.getSecond().getId()]));
        }

        public void reset() {
            hasSelfLoop = false;
            isOnStack = false;
            index = -1;
            lowlink = -1;
        }
    }
}