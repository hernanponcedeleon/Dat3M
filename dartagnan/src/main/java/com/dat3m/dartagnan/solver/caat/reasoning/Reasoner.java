package com.dat3m.dartagnan.solver.caat.reasoning;

import com.dat3m.dartagnan.solver.caat.constraints.AcyclicityConstraint;
import com.dat3m.dartagnan.solver.caat.constraints.Constraint;
import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.misc.PredicateVisitor;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.derived.ProjectionIdentityGraph;
import com.dat3m.dartagnan.solver.caat.predicates.sets.Element;
import com.dat3m.dartagnan.solver.caat.predicates.sets.SetPredicate;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;

import java.util.*;

import static com.dat3m.dartagnan.solver.caat.misc.PathAlgorithm.findShortestPath;

@SuppressWarnings("unchecked")
public class Reasoner {

    private final GraphVisitor graphVisitor = new GraphVisitor();
    private final SetVisitor setVisitor = new SetVisitor();

    public Reasoner() {
    }

    // ========================== Reason computation ==========================

    public DNF<CAATLiteral> computeViolationReasons(Constraint constraint) {
        if (!constraint.checkForViolations()) {
            return DNF.FALSE();
        }

        CAATPredicate pred = constraint.getConstrainedPredicate();
        Collection<? extends Collection<? extends Derivable>> violations = constraint.getViolations();
        List<Conjunction<CAATLiteral>> reasonList = new ArrayList<>(violations.size());

        if (constraint instanceof AcyclicityConstraint) {
            // For acyclicity constraints, it is likely that we encounter the same
            // edge multiple times (as it can be part of different cycles)
            // so we memoize the computed reasons and reuse them if possible.
            final RelationGraph constrainedGraph = (RelationGraph) pred;
            final int mapSize = violations.stream().mapToInt(Collection::size).sum() * 4 / 3;
            final Map<Edge, Conjunction<CAATLiteral>> reasonMap = new HashMap<>(mapSize);

            for (Collection<Edge> violation : (Collection<Collection<Edge>>)violations) {
                Conjunction<CAATLiteral> reason = violation.stream()
                        .map(edge -> reasonMap.computeIfAbsent(edge, key -> computeReason(constrainedGraph, key)))
                        .reduce(Conjunction.TRUE(), Conjunction::and);
                reasonList.add(reason);
            }
        } else {
            for (Collection<? extends Derivable> violation : violations) {
                Conjunction<CAATLiteral> reason = violation.stream()
                        .map(edge -> computeReason(pred, edge))
                        .reduce(Conjunction.TRUE(), Conjunction::and);
                reasonList.add(reason);
            }
        }

        return new DNF<>(reasonList);
    }

    public Conjunction<CAATLiteral> computeReason(CAATPredicate pred, Derivable prop) {
        if (pred instanceof RelationGraph rg && prop instanceof Edge edge) {
            return computeReason(rg, edge);
        } else if (pred instanceof SetPredicate sp && prop instanceof Element elem) {
            return computeReason(sp, elem);
        } else {
            return Conjunction.FALSE();
        }
    }


    public Conjunction<CAATLiteral> computeReason(RelationGraph graph, Edge edge) {
        if (!graph.contains(edge)) {
            return Conjunction.FALSE();
        }

        Conjunction<CAATLiteral> reason = graph.accept(graphVisitor, edge, null);
        assert !reason.isFalse();
        return reason;
    }

    public Conjunction<CAATLiteral> computeReason(SetPredicate set, Element ele) {
        if (!set.contains(ele)) {
            return Conjunction.FALSE();
        }

        Conjunction<CAATLiteral> reason = set.accept(setVisitor, ele, null);
        assert !reason.isFalse();
        return reason;
    }

    // ======================== Visitors ==========================
    /*
        The visitors are used to traverse the structure of the predicate hierarchy
        and compute reasons for each predicate
     */

    private class GraphVisitor implements PredicateVisitor<Conjunction<CAATLiteral>, Edge, Void> {

        @Override
        public Conjunction<CAATLiteral> visit(CAATPredicate predicate, Edge edge, Void unused) {
            throw new IllegalArgumentException(predicate.getName() + " is not supported in reasoning computation");
        }

        @Override
        public Conjunction<CAATLiteral> visitGraphUnion(RelationGraph graph, Edge edge, Void unused) {
            // We try to compute a shortest reason based on the distance to the base graphs
            Edge min = edge;
            RelationGraph next = graph;
            for (RelationGraph g : (List<RelationGraph>) graph.getDependencies()) {
                Edge e = g.get(edge);
                if (e != null && e.getDerivationLength() < min.getDerivationLength()) {
                    next = g;
                    min = e;
                }
            }

            assert next != graph;
            Conjunction<CAATLiteral> reason = computeReason(next, min);
            assert !reason.isFalse();
            return reason;

        }

        @Override
        public Conjunction<CAATLiteral> visitGraphIntersection(RelationGraph graph, Edge edge, Void unused) {
            Conjunction<CAATLiteral> reason = Conjunction.TRUE();
            for (RelationGraph g : (List<RelationGraph>) graph.getDependencies()) {
                Edge e = g.get(edge);
                reason = reason.and(computeReason(g, e));
            }
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitGraphComposition(RelationGraph graph, Edge edge, Void unused) {
            RelationGraph first = (RelationGraph) graph.getDependencies().get(0);
            RelationGraph second = (RelationGraph) graph.getDependencies().get(1);

            // We use the first composition that we find
            if (first.getEstimatedSize(edge.getFirst(), EdgeDirection.OUTGOING)
                    <= second.getEstimatedSize(edge.getSecond(), EdgeDirection.INGOING)) {
                for (Edge e1 : first.outEdges(edge.getFirst())) {
                    if (e1.getDerivationLength() >= edge.getDerivationLength()) {
                        continue;
                    }
                    Edge e2 = second.get(new Edge(e1.getSecond(), edge.getSecond()));
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
                    Edge e1 = first.get(new Edge(edge.getFirst(), e2.getFirst()));
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
        public Conjunction<CAATLiteral> visitCartesian(RelationGraph graph, Edge edge, Void unused) {
            SetPredicate lhs = (SetPredicate) graph.getDependencies().get(0);
            SetPredicate rhs = (SetPredicate) graph.getDependencies().get(1);

            Conjunction<CAATLiteral> reason = computeReason(lhs, lhs.getById(edge.getFirst()))
                    .and(computeReason(rhs, rhs.getById(edge.getSecond())));
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitGraphDifference(RelationGraph graph, Edge edge, Void unused) {
            RelationGraph lhs = (RelationGraph) graph.getDependencies().get(0);
            RelationGraph rhs = (RelationGraph) graph.getDependencies().get(1);

            if (!rhs.getDependencies().isEmpty()) {
                throw new IllegalStateException(
                        String.format("Cannot compute reason of edge %s in difference graph %s because its right-hand side %s " +
                                "is derived.", edge, graph, rhs));
            }

            Conjunction<CAATLiteral> reason = computeReason(lhs, edge)
                    .and(new EdgeLiteral(rhs, edge, false).toSingletonReason());
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitInverse(RelationGraph graph, Edge edge, Void unused) {
            Conjunction<CAATLiteral> reason = computeReason((RelationGraph) graph.getDependencies().get(0),
                    edge.inverse().withDerivationLength(edge.getDerivationLength() - 1));
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitSetIdentity(RelationGraph graph, Edge edge, Void unused) {
            assert edge.isLoop();

            SetPredicate inner = (SetPredicate) graph.getDependencies().get(0);
            Element e = inner.getById(edge.getFirst());
            return computeReason(inner, e);
        }

        @Override
        public Conjunction<CAATLiteral> visitProjectionIdentity(RelationGraph graph, Edge edge, Void unused) {
            assert edge.isLoop();

            RelationGraph inner = (RelationGraph) graph.getDependencies().get(0);
            ProjectionIdentityGraph.Dimension dim = ((ProjectionIdentityGraph)graph).getProjectionDimension();
            Iterable<Edge> edges = switch (dim) {
                case RANGE -> inner.inEdges(edge.getSecond());
                case DOMAIN -> inner.outEdges(edge.getFirst());
            };
            for (Edge e : edges) {
                // We use the first edge we find
                if (e.getDerivationLength() < edge.getDerivationLength()) {
                    Conjunction<CAATLiteral> reason = computeReason(inner, e);
                    assert !reason.isFalse();
                    return reason;
                }
            }
            throw new IllegalStateException("ProjectionIdentityGraph: No matching edge is found");
        }

        @Override
        public Conjunction<CAATLiteral> visitReflexiveClosure(RelationGraph graph, Edge edge, Void unused) {
            if (edge.isLoop()) {
                return Conjunction.TRUE();
            } else {
                Conjunction<CAATLiteral> reason = computeReason((RelationGraph) graph.getDependencies().get(0), edge);
                assert !reason.isFalse();
                return reason;
            }
        }

        @Override
        public Conjunction<CAATLiteral> visitTransitiveClosure(RelationGraph graph, Edge edge, Void unused) {
            RelationGraph inner = (RelationGraph) graph.getDependencies().get(0);
            Conjunction<CAATLiteral> reason = Conjunction.TRUE();
            List<Edge> path = findShortestPath(inner, edge.getFirst(), edge.getSecond(), edge.getDerivationLength() - 1);
            for (Edge e : path) {
                reason = reason.and(computeReason(inner, e));
            }
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitRecursiveGraph(RelationGraph graph, Edge edge, Void unused) {
            Conjunction<CAATLiteral> reason = computeReason((RelationGraph) graph.getDependencies().get(0), edge);
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitBaseGraph(RelationGraph graph, Edge edge, Void unused) {
            return new EdgeLiteral(graph, edge, true).toSingletonReason();
        }
    }

    private class SetVisitor implements PredicateVisitor<Conjunction<CAATLiteral>, Element, Void> {

        // ============================ Sets =========================

        @Override
        public Conjunction<CAATLiteral> visitSetUnion(SetPredicate set, Element ele, Void unused) {
            // We try to compute a shortest reason based on the distance to the base graphs
            Element min = ele;
            SetPredicate next = set;
            for (SetPredicate s : set.getDependencies()) {
                Element e = s.get(ele);
                if (e != null && e.getDerivationLength() < min.getDerivationLength()) {
                    next = s;
                    min = e;
                }
            }

            assert next != set;

            Conjunction<CAATLiteral> reason = computeReason(next, min);
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitSetIntersection(SetPredicate set, Element ele, Void unused) {
            Conjunction<CAATLiteral> reason = Conjunction.TRUE();
            for (SetPredicate s : set.getDependencies()) {
                Element e = set.get(ele);
                reason = reason.and(computeReason(s, e));
            }
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitSetDifference(SetPredicate set, Element ele, Void unused) {
            SetPredicate lhs = set.getDependencies().get(0);
            SetPredicate rhs = set.getDependencies().get(1);

            if (!rhs.getDependencies().isEmpty()) {
                throw new IllegalStateException(String.format("Cannot compute reason of element %s in " +
                        "set difference %s because its right-hand side %s is derived.", ele, set, rhs));
            }

            Conjunction<CAATLiteral> reason = computeReason(lhs, ele)
                    .and(new ElementLiteral(rhs, ele, false).toSingletonReason());
            assert !reason.isFalse();
            return reason;
        }

        @Override
        public Conjunction<CAATLiteral> visitBaseSet(SetPredicate set, Element ele, Void unused) {
            return new ElementLiteral(set, ele, true).toSingletonReason();
        }
    }
}
