package com.dat3m.dartagnan.solver.propagators;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;
import java.util.function.Predicate;

public class VarGraph {

    final static int TRUE = 1;
    final static int UNASSIGNED = 0;
    final static int FALSE = -1;

    int domainSize;
    Map<BooleanFormula, Edge> var2Edge = new HashMap<>();
    List<Edge>[] inEdges;
    List<Edge>[] outEdges;
    List<Edge> allEdges = new ArrayList<>();
    List<Edge> dynamicEdges = new ArrayList<>();

    private final List<Edge> trace = new ArrayList<>();
    private final List<Integer> backtrackPoints = new ArrayList<>();
    private int curLevel = 0;

    private final BooleanFormulaManager bmgr;

    @SuppressWarnings("unchecked")
    public VarGraph(int domainSize, BooleanFormulaManager bmgr) {
        this.bmgr = bmgr;
        this.domainSize = domainSize;

        inEdges = (List<Edge>[]) new List[domainSize];
        outEdges = (List<Edge>[]) new List[domainSize];
        for (int i = 0; i < domainSize; i++) {
            inEdges[i] = new ArrayList<>();
            outEdges[i] = new ArrayList<>();
        }
    }

    public Edge getEdge(BooleanFormula edgeVar) {
        return var2Edge.get(edgeVar);
    }

    public void addMustEdge(int source, int target) {
        addVarEdge(source, target, null);
    }

    public void addVarEdge(int source, int target, BooleanFormula edgeVar) {
        final Edge edge = new Edge(source, target, edgeVar);
        inEdges[target].add(edge);
        outEdges[source].add(edge);
        allEdges.add(edge);

        if (!edge.isMust()) {
            var2Edge.put(edgeVar, edge);
            edge.negEdgeVar = bmgr.not(edgeVar);
            dynamicEdges.add(edge);
        }
    }

    public void push() {
        curLevel++;
        backtrackPoints.add(trace.size());
    }

    public void pop(int numLevels) {
        curLevel -= numLevels;

        int backtrackPoint = backtrackPoints.get(curLevel);
        backtrackPoints.subList(curLevel, backtrackPoints.size()).clear();
        trace.subList(backtrackPoint, trace.size()).forEach(this::unassignEdge);
        trace.subList(backtrackPoint, trace.size()).clear();
    }

    public void assignEdge(Edge e, int value) {
        assert value == TRUE || value == FALSE;
        trace.add(e);
        e.status = value;
    }

    public void assignEdge(Edge e, boolean value) {
        assignEdge(e, value ? TRUE : FALSE);
    }

    private void unassignEdge(Edge e) {
        e.status = UNASSIGNED;
    }

    public Iterable<Edge> getUnassignedEdges() {
        final var it = new FilteredIterator(dynamicEdges, edge -> edge.status == UNASSIGNED);
        return () -> it;
    }

    public Iterable<Edge> getTrueOutEdges(int i) {
        final var it = new FilteredIterator(outEdges[i], VarGraph::isEnabledEdge);
        return () -> it;
    }

    public Iterable<Edge> getTrueInEdges(int i) {
        final var it = new FilteredIterator(outEdges[i], VarGraph::isEnabledEdge);
        return () -> it;
    }

    private static boolean isEnabledEdge(Edge e) {
        return e.status == TRUE || e.isMust();
    }

    private final static class FilteredIterator implements Iterator<Edge> {
        private final List<Edge> edges;
        private final Predicate<Edge> filter;
        private int index = -1;

        public FilteredIterator(List<Edge> edges, Predicate<Edge> filter) {
            this.edges = edges;
            this.filter = filter;
            advance();
        }

        private void advance() {
            final List<Edge> edges = this.edges;
            final Predicate<Edge> filter = this.filter;
            final int size = edges.size();
            int index = this.index;
            do {
                index++;
            } while (index < size && !filter.test(edges.get(index)));
            this.index = index;
        }

        @Override
        public boolean hasNext() {
            return index < edges.size();
        }

        @Override
        public Edge next() {
            Edge e = edges.get(index);
            advance();
            return e;
        }
    }

    public final static class Edge {
        private final int source;
        private final int target;
        transient int status = UNASSIGNED;

        private final BooleanFormula edgeVar;
        transient BooleanFormula negEdgeVar;

        public int getSource() { return source; }
        public int getTarget() { return target; }
        public BooleanFormula getEdgeVar() { return edgeVar; }
        public BooleanFormula getNegEdgeVar() { return negEdgeVar; }
        public int getStatus() { return status; }

        public Edge(int source, int target, BooleanFormula edgeVar) {
            this.source = source;
            this.target = target;
            this.edgeVar = edgeVar;
        }

        @Override
        public String toString() {
            return "%s(%d, %d)".formatted(edgeVar, source, target);
        }

        @Override
        public int hashCode() {
            return ((source << 14) - 1) + target;
        }

        @Override
        public boolean equals(Object obj) {
            return obj instanceof Edge edge && edge.source == source && edge.target == target;
        }

        public boolean isMust() { return edgeVar == null; }
    }
}
