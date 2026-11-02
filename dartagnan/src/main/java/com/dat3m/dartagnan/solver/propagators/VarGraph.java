package com.dat3m.dartagnan.solver.propagators;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.*;
import java.util.function.Predicate;

public class VarGraph {

    final static int TRUE = 1;
    final static int UNASSIGNED = 0;
    final static int FALSE = -1;

    final int domainSize;
    final Map<BooleanFormula, Edge> var2Edge = new HashMap<>();
    final List<Edge>[] inEdges;
    final List<Edge>[] outEdges;
    // Edges that are currently true. Since edges are unassigned in reverse order of assignment (by backtracking),
    // we can maintain them as stacks.
    final List<Edge>[] trueInEdges;
    final List<Edge>[] trueOutEdges;
    final List<Edge> allEdges = new ArrayList<>();
    final List<Edge> dynamicEdges = new ArrayList<>();

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
        trueInEdges = (List<Edge>[]) new List[domainSize];
        trueOutEdges = (List<Edge>[]) new List[domainSize];
        for (int i = 0; i < domainSize; i++) {
            inEdges[i] = new ArrayList<>();
            outEdges[i] = new ArrayList<>();
            trueInEdges[i] = new ArrayList<>();
            trueOutEdges[i] = new ArrayList<>();
        }
    }

    public Edge getEdge(BooleanFormula edgeVar) {
        return var2Edge.get(edgeVar);
    }

    /*
        A must-edge (x, y) is only guaranteed to exist if both x and y execute.
        It starts out unassigned and is enabled by the propagator once all literals
        in <execLitIds> (which jointly imply exec(x) /\ exec(y)) are known to be true.
     */
    public Edge addMustEdge(int source, int target, int[] execLitIds) {
        return addMustEdge(source, target, 0, execLitIds);
    }

    public Edge addMustEdge(int source, int target, int label, int[] execLitIds) {
        assert execLitIds.length > 0;
        final Edge edge = new Edge(allEdges.size(), source, target, label, null, execLitIds);
        addEdge(edge);
        return edge;
    }

    public Edge addVarEdge(int source, int target, BooleanFormula edgeVar) {
        return addVarEdge(source, target, 0, edgeVar);
    }

    // NOTE: If the same <edgeVar> is used for multiple edges, getEdge(edgeVar) returns only the last one.
    public Edge addVarEdge(int source, int target, int label, BooleanFormula edgeVar) {
        assert edgeVar != null;
        final Edge edge = new Edge(allEdges.size(), source, target, label, edgeVar, null);
        addEdge(edge);
        var2Edge.put(edgeVar, edge);
        edge.negEdgeVar = bmgr.not(edgeVar);
        dynamicEdges.add(edge);
        return edge;
    }

    private void addEdge(Edge edge) {
        final int source = edge.getSource();
        final int target = edge.getTarget();
        inEdges[target].add(edge);
        outEdges[source].add(edge);
        allEdges.add(edge);
    }

    public void push() {
        curLevel++;
        backtrackPoints.add(trace.size());
    }

    public void pop(int numLevels) {
        curLevel -= numLevels;

        int backtrackPoint = backtrackPoints.get(curLevel);
        backtrackPoints.subList(curLevel, backtrackPoints.size()).clear();
        for (int i = trace.size() - 1; i >= backtrackPoint; i--) {
            unassignEdge(trace.get(i));
        }
        trace.subList(backtrackPoint, trace.size()).clear();
    }

    public void assignEdge(Edge e, int value) {
        assert value == TRUE || value == FALSE;
        assert e.isUnassigned();
        assert !e.isMust() || value == TRUE;
        trace.add(e);
        e.value = value;
        if (value == TRUE) {
            trueOutEdges[e.source].add(e);
            trueInEdges[e.target].add(e);
        }
    }

    public void assignEdge(Edge e, boolean value) {
        assignEdge(e, value ? TRUE : FALSE);
    }

    private void unassignEdge(Edge e) {
        if (e.value == TRUE) {
            final List<Edge> out = trueOutEdges[e.source];
            final List<Edge> in = trueInEdges[e.target];
            assert out.get(out.size() - 1) == e && in.get(in.size() - 1) == e;
            out.remove(out.size() - 1);
            in.remove(in.size() - 1);
        }
        e.value = UNASSIGNED;
    }

    public Iterable<Edge> getInEdges(int i) {
        return inEdges[i];
    }

    public List<Edge> getInEdgeList(int i) { return inEdges[i]; }
    public List<Edge> getTrueInEdgeList(int i) { return trueInEdges[i]; }
    public List<Edge> getTrueOutEdgeList(int i) { return trueOutEdges[i]; }
    public List<Edge> getOutEdgeList(int i) { return outEdges[i]; }
    public int getNumEdges() { return allEdges.size(); }

    public Iterable<Edge> getTrueOutEdges(int i) {
        final var it = new FilteredIterator(outEdges[i], VarGraph::isEnabledEdge);
        return () -> it;
    }

    private static boolean isEnabledEdge(Edge e) {
        return e.value == TRUE;
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
        private final int id;
        private final int source;
        private final int target;
        private final int label;
        private transient int value = UNASSIGNED;

        private final transient BooleanFormula edgeVar;
        private transient BooleanFormula negEdgeVar;
        // Only for must-edges: ids of the execution literals that enable this edge.
        private final int[] execLitIds;

        public int getId() { return id; }
        public int getLabel() { return label; }
        public int getSource() { return source; }
        public int getTarget() { return target; }
        public BooleanFormula getEdgeVar() { return edgeVar; }
        public BooleanFormula getNegEdgeVar() { return negEdgeVar; }
        public int[] getExecLitIds() { return execLitIds; }
        public int getValue() { return value; }

        private Edge(int id, int source, int target, int label, BooleanFormula edgeVar, int[] execLitIds) {
            this.id = id;
            this.source = source;
            this.target = target;
            this.label = label;
            this.edgeVar = edgeVar;
            this.execLitIds = execLitIds;
        }

        public boolean isUnassigned() { return value == UNASSIGNED; }
        public boolean isTrue() { return value == TRUE; }
        public boolean isFalse() { return value == FALSE; }
        public boolean isMust() { return edgeVar == null; }

        @Override
        public String toString() {
            return "%s[%d](%d, %d)".formatted(edgeVar, label, source, target);
        }

        @Override
        public int hashCode() {
            return 31 * (((target << 14) - 1) + source) + label;
        }

        @Override
        public boolean equals(Object obj) {
            return obj instanceof Edge edge && edge.source == source && edge.target == target && edge.label == label;
        }
    }
}
