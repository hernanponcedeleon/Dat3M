package com.dat3m.dartagnan.solver.caat.reasoning;

import com.dat3m.dartagnan.solver.caat.graphs.ExecutionGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.binary.DifferenceGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.constraints.AcyclicityConstraint;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.constraints.Constraint;
import com.dat3m.dartagnan.solver.caat.util.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.util.GraphVisitor;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;

import java.util.*;

import static com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.utils.PathAlgorithm.findShortestPath;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.CO;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.RF;


//TODO: Check the usage of derivation length
// Especially for ReflexiveClosure and TransitiveClosure

public class Reasoner {

    private final Visitor visitor = new Visitor();

    private final Set<RelationGraph> reasoningCut = new HashSet<>();

    public Reasoner(ExecutionGraph execGraph) {
        reasoningCut.add(execGraph.getRelationGraphByName(RF));
        reasoningCut.add(execGraph.getRelationGraphByName(CO));
    }

    // ========================== Cuts ==========================
    // NOTE: Usually, a cut would be performed on the memory model directly.
    // However, we allow the use of the original WMM with a separate cut


    public Set<RelationGraph> getReasoningCut() {
        return reasoningCut;
    }


    // ========================== Cuts ==========================

    public DNF<CAATLiteral> computeViolationReasons(Constraint constraint) {
        if (!constraint.checkForViolations()) {
            return DNF.FALSE();
        }

        RelationGraph constrainedGraph = constraint.getConstrainedGraph();
        Collection<? extends Collection<Edge>> violations = constraint.getViolations();
        List<Conjunction<CAATLiteral>> reasonList = new ArrayList<>(violations.size());

        if (constraint instanceof AcyclicityConstraint) {
            // For acyclicity constraints, it is likely that we encounter the same
            // edge multiple times (as it can be part of different cycles)
            // so we memoize the computed reasons and reuse them if possible.
            final int mapSize = violations.stream().mapToInt(Collection::size).sum() * 4 / 3;
            final Map<Edge, Conjunction<CAATLiteral>> reasonMap = new HashMap<>(mapSize);

            for (Collection<Edge> violation : violations) {
                Conjunction<CAATLiteral> reason = violation.stream()
                        .map(edge -> reasonMap.computeIfAbsent(edge, key -> computeReason(constrainedGraph, key)))
                        .reduce(Conjunction.TRUE(), Conjunction::and);
                reasonList.add(reason);
            }
        } else {
            for (Collection<Edge> violation : violations) {
                Conjunction<CAATLiteral> reason = violation.stream()
                        .map(edge -> computeReason(constrainedGraph, edge))
                        .reduce(Conjunction.TRUE(), Conjunction::and);
                reasonList.add(reason);
            }
        }

        return new DNF<>(reasonList);
    }

    public Conjunction<CAATLiteral> computeReason(RelationGraph graph, Edge edge) {
        if (!graph.contains(edge)) {
            return Conjunction.FALSE();
        }

        Conjunction<CAATLiteral> reason = graph.accept(visitor, edge, null);
        assert !reason.isFalse();
        return reason;
    }

    // ======================== Visitor ==========================
    /*
        The visitor is used to traverse the structure of the graph hierarchy
        and compute reasons for each graph.
     */
    private class Visitor implements GraphVisitor<Conjunction<CAATLiteral>, Edge, Void> {

        @Override
        public Conjunction<CAATLiteral> visit(RelationGraph graph, Edge edge, Void unused) {
            throw new IllegalArgumentException(graph.getName() + " is not supported in reasoning computation");
        }

        @Override
        public Conjunction<CAATLiteral> visitUnion(RelationGraph graph, Edge edge, Void unused) {
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

            Conjunction<CAATLiteral> reason = computeReason(next, min);
            assert !reason.isFalse();
            return reason;

        }

        @Override
        public Conjunction<CAATLiteral> visitIntersection(RelationGraph graph, Edge edge, Void unused) {
            Conjunction<CAATLiteral> reason = Conjunction.TRUE();
            for (RelationGraph g : graph.getDependencies()) {
                Edge e = g.get(edge).orElseThrow(() ->
                        new IllegalStateException("Did not find a reason for " + edge + " in " + graph.getName()));
                reason = reason.and(computeReason(g, e));
            }
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitComposition(RelationGraph graph, Edge edge, Void unused) {
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
                        Conjunction<CAATLiteral> reason = computeReason(first, e1).and(computeReason(second, e2));
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
                        Conjunction<CAATLiteral> reason = computeReason(first, e1).and(computeReason(second, e2));
                        assert !reason.isFalse();
                        return reason;
                    }
                }
            }

            throw new IllegalStateException("Did not find a reason for " + edge + " in " + graph.getName());
        }

        @Override
        public Conjunction<CAATLiteral> visitDifference(RelationGraph graph, Edge edge, Void unused) {
            DifferenceGraph difGraph = (DifferenceGraph)graph;
            RelationGraph rhs = difGraph.getSecond();
            //TODO: This is only correct as long as the second operand of the difference
            // is a static relation. For now we work with this assumption and check it here.

            if (rhs.getDependencies().size() > 0) {
                throw new IllegalStateException(String.format("Cannot compute reason of edge %s in difference graph %s because its right-hand side %s " +
                        "is derived.", edge, difGraph, rhs ));
            }



            Conjunction<CAATLiteral> reason = computeReason(difGraph.getFirst(), edge).and(new EdgeLiteral(rhs.getName(), edge, true).toSingletonReason());
            assert !reason.isFalse();
            return reason;

            /*if (!graphRelMap.get(rhs).getMaxTupleSet().contains(edge.toTuple())) {
                return reason;
            } else if (reasoningCut.contains(rhs)) {
                return reason.and(new Conjunction<>(new EdgeCoreLiteral(rhs.getName(), edge).getOpposite()));
            } else {
                throw new IllegalStateException(String.format("Cannot compute reason of edge %s in difference graph %s because its right-hand side %s " +
                        "is non-basic and edge containment cannot be statically excluded.", edge, difGraph, rhs ));
            }*/
        }

        @Override
        public Conjunction<CAATLiteral> visitInverse(RelationGraph graph, Edge edge, Void unused) {
            Conjunction<CAATLiteral> reason = computeReason(graph.getDependencies().get(0), edge.inverse().withDerivLength(edge.getDerivationLength() - 1));
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitRangeIdentity(RelationGraph graph, Edge edge, Void unused) {
            if (!edge.isLoop()) {
                throw new IllegalArgumentException(edge + " is no loop in " + graph.getName());
            }

            RelationGraph inner = graph.getDependencies().get(0);
            for (Edge inEdge : inner.inEdges(edge.getSecond())) {
                // TODO: We could look for the edge with the least derivation length here
                if (inEdge.getDerivationLength() < edge.getDerivationLength()) {
                    Conjunction<CAATLiteral> reason = computeReason(inner, inEdge);
                    assert !reason.isFalse();
                    return reason;
                }
            }
            throw new IllegalStateException("RangeIdentityGraph: No matching edge is found");
        }

        @Override
        public Conjunction<CAATLiteral> visitReflexiveClosure(RelationGraph graph, Edge edge, Void unused) {
            if (edge.isLoop()) {
                return Conjunction.TRUE();
            } else {
                //TODO: Make sure that we can simply delegate the edge through.
                // The reflexive closure right now does NOT change the derivation length
                Conjunction<CAATLiteral> reason = computeReason(graph.getDependencies().get(0), edge);
                assert !reason.isFalse();
                return reason;
            }
        }

        @Override
        public Conjunction<CAATLiteral> visitTransitiveClosure(RelationGraph graph, Edge edge, Void unused) {
            RelationGraph inner = graph.getDependencies().get(0);
            Conjunction<CAATLiteral> reason = Conjunction.TRUE();
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
        public Conjunction<CAATLiteral> visitRecursive(RelationGraph graph, Edge edge, Void unused) {
            Conjunction<CAATLiteral> reason = computeReason(graph.getDependencies().get(0), edge);
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitBase(RelationGraph graph, Edge edge, Void unused) {
            return new EdgeLiteral(graph.getName(), edge, false).toSingletonReason();
        }

    }


}
