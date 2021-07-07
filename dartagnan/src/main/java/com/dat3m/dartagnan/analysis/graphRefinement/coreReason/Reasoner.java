package com.dat3m.dartagnan.analysis.graphRefinement.coreReason;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.ExecutionGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.axiom.GraphAxiom;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.basic.CoherenceGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat.FenceGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat.LocationGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat.ReadFromGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary.RecursiveGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.DNF;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.SortedClauseSet;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.MemEvent;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.google.common.collect.BiMap;
import com.google.common.collect.Maps;

import java.util.*;

import static com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.PathAlgorithm.findShortestPathBiDir;


//TODO: Check the usage of derivation length
// Especially for ReflexiveClosure and TransitiveClosure
public class Reasoner {

    private final ExecutionGraph execGraph;
    private final BranchEquivalence eq;
    private final BiMap<EventGraph, Relation> graphRelMap;
    private final boolean useMinTupleReasoning;
    private final Relation co;
    private final Visitor visitor = new Visitor();

    // We track for each recursive graph the edges we visit recursively
    // If we recursively visit some edge twice, we end up in a cyclic reasoning (causing an exception right now)
    //TODO: For edges that do not depend on co, we may want to store the computed violations
    // to reuse them if possible.
    private final Map<EventGraph, Set<Edge>> visitedMap = Maps.newIdentityHashMap();

    public Reasoner(ExecutionGraph execGraph, boolean useMinTupleReasoning) {
        this.execGraph = execGraph;
        this.eq = execGraph.getVerificationTask().getBranchEquivalence();
        this.co = execGraph.getVerificationTask().getMemoryModel().getRelationRepository().getRelation("co");
        this.graphRelMap = execGraph.getRelationGraphMap().inverse();
        this.useMinTupleReasoning = useMinTupleReasoning;

        execGraph.getEventGraphs().stream().filter(graph -> graph instanceof RecursiveGraph)
                .forEach(g -> visitedMap.put(g, new HashSet<>()));
    }


    public DNF<CoreLiteral> computeViolationReasons(GraphAxiom axiom) {
        if (!axiom.checkForViolations()) {
            return DNF.FALSE;
        }

        SortedClauseSet<CoreLiteral> clauseSet = new SortedClauseSet<>();
        List<List<Edge>> violations = axiom.getViolations();
        for (List<Edge> violation : violations) {
            Conjunction<CoreLiteral> reason = Conjunction.TRUE;
            for (Edge e : violation) {
                reason = reason.and(computeReason(axiom.getDependencies().get(0), e));
            }
            clauseSet.add(simplifyReason(reason));
        }

        clauseSet.simplify();
        return clauseSet.toDNF();
    }

    public Conjunction<CoreLiteral> computeReason(EventGraph graph, Edge edge) {
        if (!graph.contains(edge)) {
            return Conjunction.FALSE;
        }
        Conjunction<CoreLiteral> reason = graph.accept(visitor, edge, null);
        assert !reason.isFalse();
        return simplifyReason(reason);
    }

    public Conjunction<CoreLiteral> simplifyReason(Conjunction<CoreLiteral> reason) {
        return reason.removeIf(lit -> canBeRemoved(lit, reason));
    }



    // ================= Private Methods ==================



    private Conjunction<CoreLiteral> tryGetStaticReason(EventGraph graph, Edge e) {
        if (!useMinTupleReasoning) {
            return null;
        }

        if (graph == execGraph.getWoGraph()) {
            graph = execGraph.getCoGraph();
        }
        if (graphRelMap.get(graph).getMinTupleSet().contains(e.toTuple())) {
            return getExecReason(e);
        }
        return null;
    }

    private Conjunction<CoreLiteral> getRfReason(Edge e) {
        if (!e.getFirst().isWrite() || !e.getSecond().isRead()) {
            return Conjunction.FALSE;
        } else {
            return new Conjunction<>(new RfLiteral(e));
        }
    }

    private Conjunction<CoreLiteral> getCoherenceReason(Edge e) {
        if (e.getFirst().isInit() && e.getSecond().isWrite()) {
            return getAddressReason(e);
        }
        if (!e.getFirst().isWrite() || !e.getSecond().isWrite()) {
            return Conjunction.FALSE;
        }
        return new Conjunction<>(new CoLiteral(e)).and(getAddressReason(e));
    }

    private Conjunction<CoreLiteral> getAddressReason(Edge e) {
        if (!e.getFirst().isMemoryEvent() || !e.getSecond().isMemoryEvent()) {
            return Conjunction.FALSE;
        }
        MemEvent e1 = (MemEvent) e.getFirst().getEvent();
        MemEvent e2 = (MemEvent) e.getSecond().getEvent();
        if (e1.getMaxAddressSet().size() == 1 && e1.getMaxAddressSet().equals(e2.getMaxAddressSet())) {
            return getExecReason(e);
        } else {
            return new Conjunction<>(new AddressLiteral(e)).and(getExecReason(e));
        }
    }

    private Conjunction<CoreLiteral> getExecReason(Edge e) {
        Event e1 = e.getFirst().getEvent();
        Event e2 = e.getSecond().getEvent();
        if (e1.getCId() > e2.getCId()) {
            Event temp = e1;
            e1 = e2;
            e2 = temp;
            e = e.inverse();
        }
        if (eq.isImplied(e1, e2)) {
            return new Conjunction<>(new EventLiteral(e.getFirst()));
        } else if (eq.isImplied(e2, e1)) {
            return new Conjunction<>(new EventLiteral(e.getSecond()));
        } else {
            return new Conjunction<>(new EventLiteral(e.getFirst()), new EventLiteral(e.getSecond()));
        }
    }


    private boolean canBeRemoved(CoreLiteral literal, Conjunction<CoreLiteral> clause) {
        if (literal instanceof EventLiteral) {
            final BranchEquivalence eq = this.eq;
            EventLiteral eventLit = (EventLiteral) literal;
            Event e = eventLit.getEvent().getEvent();
            return clause.getLiterals().stream().anyMatch(x -> {
                if (!(x instanceof RfLiteral))
                    return false;
                Edge edge = ((AbstractEdgeLiteral) x).getEdge();
                return eq.isImplied(edge.getFirst().getEvent(), e) || eq.isImplied(edge.getSecond().getEvent(), e);
            });
        }

        return false;
    }

    // ======================== Visitor ==========================
    /*
        The visitor is used to traverse the structure of the graph hierarchy.
     */
    private class Visitor implements GraphVisitor<Conjunction<CoreLiteral>, Edge, Void> {

        @Override
        public Conjunction<CoreLiteral> visit(EventGraph graph, Edge edge, Void unused) {
            throw new IllegalArgumentException(graph.getName() + " is not supported in reasoning computation");
        }

        @Override
        public Conjunction<CoreLiteral> visitUnion(EventGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
            if (reason != null) {
                return reason;
            }

            // We try to compute a shortest reason based on the distance to the base graphs
            List<EventGraph> deps = new ArrayList<>(graph.getDependencies());
            deps.sort(Comparator.comparingInt(execGraph::getShortestDerivationComplexity));

            Edge min = edge;
            EventGraph next = graph;
            for (EventGraph g : deps) {
                Edge e = g.get(edge);
                if (e != null && e.getDerivationLength() < min.getDerivationLength()) {
                    next = g;
                    min = e;
                }
            }
            if (next == graph) {
                throw new IllegalStateException("Did not find a reason for " + edge + " in " + graph.getName());
            }
            reason = next.accept(this, min, null);
            assert !reason.isFalse();
            return reason;

        }

        @Override
        public Conjunction<CoreLiteral> visitIntersection(EventGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
            if (reason != null) {
                return reason;
            }


            reason = Conjunction.TRUE;
            for (EventGraph g : graph.getDependencies()) {
                Edge e = g.get(edge);
                if (e != null) {
                    reason = reason.and(g.accept(this, e, unused));
                } else {
                    throw new IllegalStateException("Did not find a reason for " + edge + " in " + graph.getName());
                }
            }
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CoreLiteral> visitComposition(EventGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
            if (reason != null) {
                return reason;
            }

            EventGraph first = graph.getDependencies().get(0);
            EventGraph second = graph.getDependencies().get(1);

            if (first.getEstimatedSize(edge.getFirst(), EdgeDirection.Outgoing)
                    <= second.getEstimatedSize(edge.getSecond(), EdgeDirection.Ingoing)) {
                for (Edge e1 : first.outEdges(edge.getFirst())) {
                    if (e1.getDerivationLength() >= edge.getDerivationLength()) {
                        continue;
                    }
                    Edge e2 = second.get(new Edge(e1.getSecond(), edge.getSecond()));
                    if (e2 != null && e2.getDerivationLength() < edge.getDerivationLength()) {
                        reason = first.accept(this, e1, null).and(second.accept(this, e2, null));
                        assert !reason.isFalse();
                        return reason;
                    }
                }
            } else {
                for (Edge e2 : second.inEdges(edge.getSecond())) {
                    if (e2.getDerivationLength() >= edge.getDerivationLength()) {
                        continue;
                    }
                    Edge e1 = first.get(new Edge(edge.getFirst(), e2.getFirst()));
                    if (e1 != null && e1.getDerivationLength() < edge.getDerivationLength()) {
                        reason = first.accept(this, e1, null).and(second.accept(this, e2, null));
                        assert !reason.isFalse();
                        return reason;
                    }
                }
            }

            throw new IllegalStateException("Did not find a reason for " + edge + " in " + graph.getName());
        }

        @Override
        public Conjunction<CoreLiteral> visitDifference(EventGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
            if (reason != null) {
                return reason;
            }

            // TOOD: Fix this for non-static relations?
            reason = graph.getDependencies().get(0).accept(this, edge, unused);
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CoreLiteral> visitInverse(EventGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
            if (reason != null) {
                return reason;
            }

            reason = graph.getDependencies().get(0).accept(this, edge.inverse().with(edge.getDerivationLength() - 1), unused);
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CoreLiteral> visitRangeIdentity(EventGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
            if (reason != null) {
                return reason;
            }
            if (!edge.isLoop()) {
                throw new IllegalArgumentException(edge + " is no loop in " + graph.getName());
            }

            EventGraph inner = graph.getDependencies().get(0);
            for (Edge inEdge : inner.inEdges(edge.getSecond())) {
                // TODO: We could look for the edge with the least derivation length here
                if (inEdge.getDerivationLength() < edge.getDerivationLength()) {
                    return inner.accept(this, inEdge, unused);
                }
            }
            throw new IllegalStateException("RangeIdentityGraph: No matching edge is found");
        }

        @Override
        public Conjunction<CoreLiteral> visitReflexiveClosure(EventGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
            if (reason != null) {
                return reason;
            }

            if (edge.isLoop()) {
                return new Conjunction<>(new EventLiteral(edge.getFirst()));
            } else {
                //TODO: Make sure that we can simply delegate the edge through
                // The reflexive closure right now does NOT change the derivation length
                reason = graph.getDependencies().get(0).accept(this, edge, unused);
                assert !reason.isFalse();
                return reason;
            }
        }

        @Override
        public Conjunction<CoreLiteral> visitTransitiveClosure(EventGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
            if (reason != null) {
                return reason;
            }

            EventGraph inner = graph.getDependencies().get(0);
            reason = Conjunction.TRUE;
            //TODO: Here might be a problem with the derivation length (will fix this later!)
            List<Edge> path = findShortestPathBiDir(inner, edge.getFirst(), edge.getSecond(),  edge.getDerivationLength());
            for (Edge e : path) {
                reason = reason.and(inner.accept(this, e, unused));
            }
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CoreLiteral> visitRecursive(EventGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
            if (reason != null) {
                return reason;
            }

            Set<Edge> visited = visitedMap.get(graph);
            if (visited.contains(edge)) {
                throw new IllegalStateException(edge.toString() + " got visited recursively in " + graph.getName());
            }

            visited.add(edge);
            reason = graph.getDependencies().get(0).accept(this, edge, unused);
            assert !reason.isFalse();
            visited.remove(edge);

            return reason;
        }

        @Override
        public Conjunction<CoreLiteral> visitBase(EventGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
            if (reason != null) {
                return reason;
            }

            if (graph instanceof ReadFromGraph) {
                return visitRf(graph, edge, unused);
            } else if (graph instanceof CoherenceGraph) {
                return visitWo(graph, edge, unused);
            } else if (graph instanceof LocationGraph) {
                return visitLoc(graph, edge, unused);
            } else if (graph instanceof FenceGraph) {
                return visitFence(graph, edge, unused);
            } else {
                return visitStatic(graph, edge, unused);
            }
        }

        private Conjunction<CoreLiteral> visitFence(EventGraph graph, Edge edge, Void unused) {
            FenceGraph fenceGraph = (FenceGraph) graph;
            EventData fence = fenceGraph.getNextFence(edge.getFirst());

            return getExecReason(edge).and(new Conjunction<>(new EventLiteral(fence)));
        }

        private Conjunction<CoreLiteral> visitRf(EventGraph graph, Edge edge, Void unused) {
            return getRfReason(edge);
        }

        private Conjunction<CoreLiteral> visitWo(EventGraph graph, Edge edge, Void unused) {
            if (!useMinTupleReasoning) {
                // We still use minTupleSets for Co for now
                if (co.getMinTupleSet().contains(edge.toTuple())) {
                    return getExecReason(edge);
                }
            }
            return getCoherenceReason(edge);
        }

        private Conjunction<CoreLiteral> visitLoc(EventGraph graph, Edge edge, Void unused) {
            return getAddressReason(edge);
        }

        private Conjunction<CoreLiteral> visitStatic(EventGraph graph, Edge edge, Void unused) {
            return getExecReason(edge);
        }
    }


}
