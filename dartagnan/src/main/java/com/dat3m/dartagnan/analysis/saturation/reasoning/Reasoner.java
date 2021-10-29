package com.dat3m.dartagnan.analysis.saturation.reasoning;

import com.dat3m.dartagnan.analysis.saturation.graphs.ExecutionGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.binary.DifferenceGraph;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.constraints.AcyclicityConstraint;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.constraints.Constraint;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.stat.FenceGraph;
import com.dat3m.dartagnan.analysis.saturation.logic.Conjunction;
import com.dat3m.dartagnan.analysis.saturation.logic.DNF;
import com.dat3m.dartagnan.analysis.saturation.logic.SortedCubeSet;
import com.dat3m.dartagnan.analysis.saturation.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.saturation.util.GraphVisitor;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.equivalence.BranchEquivalence;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.google.common.collect.BiMap;

import java.util.*;

import static com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils.PathAlgorithm.findShortestPath;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;


//TODO: Check the usage of derivation length
// Especially for ReflexiveClosure and TransitiveClosure
public class Reasoner {

    private final BranchEquivalence eq;
    private final BiMap<RelationGraph, Relation> graphRelMap;
    private final boolean useMinTupleReasoning;
    private final Visitor visitor = new Visitor();

    private final Set<RelationGraph> reasoningCut = new HashSet<>();

    public Reasoner(ExecutionGraph execGraph, boolean useMinTupleReasoning) {
        this.eq = execGraph.getVerificationTask().getBranchEquivalence();
        this.graphRelMap = execGraph.getRelationGraphMap().inverse();
        this.useMinTupleReasoning = useMinTupleReasoning;

        reasoningCut.add(execGraph.getRelationGraphByName(RF));
        reasoningCut.add(execGraph.getRelationGraphByName(CO));
    }

    public Set<RelationGraph> getReasoningCut() {
        return reasoningCut;
    }

    public DNF<CoreLiteral> computeViolationReasons(Constraint constraint) {
        if (!constraint.checkForViolations()) {
            return DNF.FALSE();
        }

        RelationGraph constrainedGraph = constraint.getConstrainedGraph();
        SortedCubeSet<CoreLiteral> reasonSet = new SortedCubeSet<>();
        Collection<? extends Collection<Edge>> violations = constraint.getViolations();

        if (constraint instanceof AcyclicityConstraint) {
            // For acyclicity constraints, it is likely that we encounter the same
            // edge multiple times (as it can be part of different cycles)
            // so we memoize the computed reasons and reuse them if possible.
            final int mapSize = violations.stream().mapToInt(Collection::size).sum() * 4 / 3;
            final Map<Edge, Conjunction<CoreLiteral>> reasonMap = new HashMap<>(mapSize);

            for (Collection<Edge> violation : violations) {
                Conjunction<CoreLiteral> reason = violation.stream()
                        .map(edge -> reasonMap.computeIfAbsent(edge, key -> computeReason(constrainedGraph, key)))
                        .reduce(Conjunction.TRUE(), Conjunction::and);
                reasonSet.add(simplifyReason(reason));
            }
        } else {
            for (Collection<Edge> violation : violations) {
                Conjunction<CoreLiteral> reason = violation.stream()
                        .map(edge -> computeReason(constrainedGraph, edge))
                        .reduce(Conjunction.TRUE(), Conjunction::and);
                reasonSet.add(simplifyReason(reason));
            }
        }

        reasonSet.simplify();
        return reasonSet.toDNF();
    }

    public Conjunction<CoreLiteral> computeReason(RelationGraph graph, Edge edge) {
        if (!graph.contains(edge)) {
            return Conjunction.FALSE();
        }

        Conjunction<CoreLiteral> reason = tryGetStaticReason(graph, edge);
        if (reason != null) {
            return reason;
        }

        if (reasoningCut.contains(graph)) {
            return new Conjunction<>(new EdgeLiteral(graph.getName(), edge));
        }

        reason = graph.accept(visitor, edge, null);
        assert !reason.isFalse();
        return simplifyReason(reason);
    }

    public Conjunction<CoreLiteral> simplifyReason(Conjunction<CoreLiteral> reason) {
        return reason.removeIf(lit -> canBeRemoved(lit, reason));
    }



    // ================= Private Methods ==================

    private Conjunction<CoreLiteral> tryGetStaticReason(RelationGraph graph, Edge e) {
        if (useMinTupleReasoning) {
            // We will probably always use minTupleReasoning, but this
            // is for testing purposes here.
            // Refinement should ideally work even without having min tuples
            if (graphRelMap.get(graph).getMinTupleSet().contains(e.toTuple())) {
                return getExecReason(e);
            }
        }
        return null;
    }

    private Conjunction<CoreLiteral> getExecReason(Edge edge) {
        Event e1 = edge.getFirst().getEvent();
        Event e2 = edge.getSecond().getEvent();

        if (e1.getCId() > e2.getCId()) {
            // Normalize edge direction
            Event temp = e1;
            e1 = e2;
            e2 = temp;
            edge = edge.inverse();
        }

        EventData eData1 = edge.getFirst();
        EventData eData2 = edge.getSecond();

        if (!e1.cfImpliesExec() || !e2.cfImpliesExec()) {
            return new Conjunction<>(new EventLiteral(eData1), new EventLiteral(eData2));
        } else if (eq.isImplied(e1, e2)) {
            return new Conjunction<>(new EventLiteral(eData1));
        } else if (eq.isImplied(e2, e1)) {
            return new Conjunction<>(new EventLiteral(eData2));
        } else {
            return new Conjunction<>(new EventLiteral(eData1), new EventLiteral(eData2));
        }
    }

    // This method decides whether <literal> can be removed from <clause> cause it
    // is already implied by the other literals in <clause>
    private boolean canBeRemoved(CoreLiteral literal, Conjunction<CoreLiteral> clause) {
        if (literal instanceof EventLiteral) {
            // EventLiterals may be implied by EdgeLiterals other than AddressLiterals
            final BranchEquivalence eq = this.eq;
            EventLiteral eventLit = (EventLiteral) literal;
            Event e = eventLit.getEventData().getEvent();
            return e.cfImpliesExec() && clause.getLiterals().stream().filter(x -> x instanceof EdgeLiteral).anyMatch(x -> {
                Edge edge = ((EdgeLiteral) x).getEdge();
                return eq.isImplied(edge.getFirst().getEvent(), e) || eq.isImplied(edge.getSecond().getEvent(), e);
            });
        } else if (literal instanceof AddressLiteral) {
            // AddressLiterals may be implied by co or rf literals
            AddressLiteral lit = (AddressLiteral)literal;
            Edge e = new Edge(lit.getFirst(), lit.getSecond());
            Edge eOpp = e.inverse();
            return clause.getLiterals().stream().filter(x -> x instanceof EdgeLiteral).anyMatch( x -> {
                EdgeLiteral edgeLit = (EdgeLiteral)x;
                if (edgeLit.getName().equals(RF) || edgeLit.getName().equals(CO)) {
                    return e.equals(edgeLit.getEdge()) || eOpp.equals(edgeLit.getEdge());
                } else {
                    return false;
                }
            });
        }

        return false;
    }

    // ======================== Visitor ==========================
    /*
        The visitor is used to traverse the structure of the graph hierarchy
        and compute reasons for each graph.
     */
    private class Visitor implements GraphVisitor<Conjunction<CoreLiteral>, Edge, Void> {

        @Override
        public Conjunction<CoreLiteral> visit(RelationGraph graph, Edge edge, Void unused) {
            throw new IllegalArgumentException(graph.getName() + " is not supported in reasoning computation");
        }

        @Override
        public Conjunction<CoreLiteral> visitUnion(RelationGraph graph, Edge edge, Void unused) {
            // We try to compute a shortest reason based on the distance to the base graphs
            Edge min = edge;
            RelationGraph next = graph;
            for (RelationGraph g : graph.getDependencies()) {
                Edge e = g.get(edge).orElse(null);
                if (e != null && e.getDerivationLength() < min.getDerivationLength()) {
                    next = g;
                    min = e;
                }
            }
            if (next == graph) {
                throw new IllegalStateException("Did not find a reason for " + edge + " in " + graph.getName());
            }

            Conjunction<CoreLiteral> reason = computeReason(next, min);
            assert !reason.isFalse();
            return reason;

        }

        @Override
        public Conjunction<CoreLiteral> visitIntersection(RelationGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = Conjunction.TRUE();
            for (RelationGraph g : graph.getDependencies()) {
                Edge e = g.get(edge).orElseThrow(() ->
                        new IllegalStateException("Did not find a reason for " + edge + " in " + graph.getName()));
                reason = reason.and(computeReason(g, e));
            }
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CoreLiteral> visitComposition(RelationGraph graph, Edge edge, Void unused) {
            RelationGraph first = graph.getDependencies().get(0);
            RelationGraph second = graph.getDependencies().get(1);

            //TODO: We could try to look for the edge composition that leads to the smallest
            // derivation length, or generally, use some other composition than the first
            // we find.
            if (first.getEstimatedSize(edge.getFirst(), EdgeDirection.OUTGOING)
                    <= second.getEstimatedSize(edge.getSecond(), EdgeDirection.INGOING)) {
                for (Edge e1 : first.outEdges(edge.getFirst())) {
                    if (e1.getDerivationLength() >= edge.getDerivationLength()) {
                        continue;
                    }
                    Edge e2 = second.get(new Edge(e1.getSecond(), edge.getSecond())).orElse(null);
                    if (e2 != null && e2.getDerivationLength() < edge.getDerivationLength()) {
                        Conjunction<CoreLiteral> reason = computeReason(first, e1).and(computeReason(second, e2));
                        assert !reason.isFalse();
                        return reason;
                    }
                }
            } else {
                for (Edge e2 : second.inEdges(edge.getSecond())) {
                    if (e2.getDerivationLength() >= edge.getDerivationLength()) {
                        continue;
                    }
                    Edge e1 = first.get(new Edge(edge.getFirst(), e2.getFirst())).orElse(null);
                    if (e1 != null && e1.getDerivationLength() < edge.getDerivationLength()) {
                        Conjunction<CoreLiteral> reason = computeReason(first, e1).and(computeReason(second, e2));
                        assert !reason.isFalse();
                        return reason;
                    }
                }
            }

            throw new IllegalStateException("Did not find a reason for " + edge + " in " + graph.getName());
        }

        @Override
        public Conjunction<CoreLiteral> visitDifference(RelationGraph graph, Edge edge, Void unused) {
            DifferenceGraph difGraph = (DifferenceGraph)graph;
            RelationGraph rhs = difGraph.getSecond();
            //TODO: This is only correct as long as the second operand of the difference
            // is a static relation. For now we work with this assumption and check it here.

            Conjunction<CoreLiteral> reason = computeReason(difGraph.getFirst(), edge);
            assert !reason.isFalse();

            if (!graphRelMap.get(rhs).getMaxTupleSet().contains(edge.toTuple())) {
                return reason;
            } else if (reasoningCut.contains(rhs)) {
                return reason.and(new Conjunction<>(new EdgeLiteral(rhs.getName(), edge).getOpposite()));
            } else {
                throw new IllegalStateException(String.format("Cannot compute reason of edge %s in difference graph %s because its right-hand side %s " +
                        "is non-basic and edge containment cannot be statically excluded.", edge, difGraph, rhs ));
            }
        }

        @Override
        public Conjunction<CoreLiteral> visitInverse(RelationGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = computeReason(graph.getDependencies().get(0), edge.inverse().withDerivLength(edge.getDerivationLength() - 1));
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CoreLiteral> visitRangeIdentity(RelationGraph graph, Edge edge, Void unused) {
            if (!edge.isLoop()) {
                throw new IllegalArgumentException(edge + " is no loop in " + graph.getName());
            }

            RelationGraph inner = graph.getDependencies().get(0);
            for (Edge inEdge : inner.inEdges(edge.getSecond())) {
                // TODO: We could look for the edge with the least derivation length here
                if (inEdge.getDerivationLength() < edge.getDerivationLength()) {
                    Conjunction<CoreLiteral> reason = computeReason(inner, inEdge);
                    assert !reason.isFalse();
                    return reason;
                }
            }
            throw new IllegalStateException("RangeIdentityGraph: No matching edge is found");
        }

        @Override
        public Conjunction<CoreLiteral> visitReflexiveClosure(RelationGraph graph, Edge edge, Void unused) {
            if (edge.isLoop()) {
                return new Conjunction<>(new EventLiteral(edge.getFirst()));
            } else {
                //TODO: Make sure that we can simply delegate the edge through.
                // The reflexive closure right now does NOT change the derivation length
                Conjunction<CoreLiteral> reason = computeReason(graph.getDependencies().get(0), edge);
                assert !reason.isFalse();
                return reason;
            }
        }

        @Override
        public Conjunction<CoreLiteral> visitTransitiveClosure(RelationGraph graph, Edge edge, Void unused) {
            RelationGraph inner = graph.getDependencies().get(0);
            Conjunction<CoreLiteral> reason = Conjunction.TRUE();
            //TODO: Here might be a problem with the derivation length.
            // Depending on the implementation of findShortestPath, there might be an off-by-one error
            // The path we look for should have strictly smaller derivation length on each edge
            List<Edge> path = findShortestPath(inner, edge.getFirst(), edge.getSecond(), edge.getDerivationLength() - 1);
            for (Edge e : path) {
                reason = reason.and(computeReason(inner, e));
            }
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CoreLiteral> visitRecursive(RelationGraph graph, Edge edge, Void unused) {
            Conjunction<CoreLiteral> reason = computeReason(graph.getDependencies().get(0), edge);
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CoreLiteral> visitBase(RelationGraph graph, Edge edge, Void unused) {

            if (graph.getName().equals(RF) || graph.getName().equals(CO)) {
                // This is a fallback as RF and CO should be part of the cut by default
                return new Conjunction<>(new EdgeLiteral(graph.getName(), edge));
            } else if (graph.getName().equals(LOC)) {
                return new Conjunction<>(new AddressLiteral(edge)).and(getExecReason(edge));
            } else if (graph instanceof FenceGraph) {
                FenceGraph fenceGraph = (FenceGraph) graph;
                EventData fence = fenceGraph.getNextFence(edge.getFirst());

                return getExecReason(edge).and(new Conjunction<>(new EventLiteral(fence)));
            } else {
                //TODO: We might have to treat Data, Addr and Ctrl differently,
                // potentially adding new base literals for those
                return getExecReason(edge);
            }
        }

    }


}
