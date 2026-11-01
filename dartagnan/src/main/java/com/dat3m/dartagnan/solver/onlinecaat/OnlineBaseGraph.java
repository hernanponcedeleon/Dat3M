package com.dat3m.dartagnan.solver.onlinecaat;

import com.dat3m.dartagnan.solver.caat.domain.Domain;
import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.misc.PairMap;
import com.dat3m.dartagnan.solver.caat.predicates.CAATPredicate;
import com.dat3m.dartagnan.solver.caat.predicates.Derivable;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.AbstractBaseGraph;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.base.SimpleGraph;
import com.dat3m.dartagnan.wmm.Relation;

import java.util.*;
import java.util.stream.Stream;

/*
    A base relation of the online theory.
    The relation is described by a fixed set of candidate pairs (the may-set restricted to the domain).
    Each pair is either
        - static (atom = -1): the edge holds iff both events are executed, or
        - dynamic (atom >= 0): the edge holds iff both events are executed and the atom is true.
    The graph materializes exactly those edges that are known to hold under the current partial assignment.

    NOTE: For static pairs, <get>/<contains> also answer positively if the edge is not yet materialized.
    This is sound, because CAAT only queries edges whose endpoints are known to be executed
    (every materialized edge implies execution of its endpoints).
    It is required for static relations that are used on the right-hand side of differences.
 */
public final class OnlineBaseGraph extends AbstractBaseGraph {

    final Relation relation;
    final boolean execInReason;
    private final OnlineCAATPropagator theory;

    // Pair data (initialized lazily via <init>)
    int[] src;
    int[] dst;
    int[] atom;
    private int[][] incident;
    private PairMap<Integer> pairIndex; // Used for large domains
    private int[][] denseIndex;          // Used for small domains: denseIndex[a][b] = pair + 1 (0 = no pair)
    private final boolean isStatic;

    private final SimpleGraph graph = new SimpleGraph();

    OnlineBaseGraph(OnlineCAATPropagator theory, Relation relation, boolean execInReason, boolean isStatic) {
        this.theory = theory;
        this.relation = relation;
        this.execInReason = execInReason;
        this.isStatic = isStatic;
    }

    boolean isInitialized() { return src != null; }

    void init(int[] src, int[] dst, int[] atom, int domainSize) {
        this.src = src;
        this.dst = dst;
        this.atom = atom;
        final boolean dense = domainSize <= 1024;
        if (dense) {
            denseIndex = new int[domainSize][];
        } else {
            pairIndex = new PairMap<>(src.length + 1);
        }
        final int[] degree = new int[domainSize];
        for (int p = 0; p < src.length; p++) {
            if (dense) {
                if (denseIndex[src[p]] == null) {
                    denseIndex[src[p]] = new int[domainSize];
                }
                if (denseIndex[src[p]][dst[p]] == 0) {
                    denseIndex[src[p]][dst[p]] = p + 1;
                }
            } else {
                pairIndex.putIfAbsent(src[p], dst[p], p);
            }
            degree[src[p]]++;
            if (src[p] != dst[p]) {
                degree[dst[p]]++;
            }
            assert !isStatic || atom[p] < 0;
        }
        this.incident = new int[domainSize][];
        for (int i = 0; i < domainSize; i++) {
            incident[i] = new int[degree[i]];
            degree[i] = 0;
        }
        for (int p = 0; p < src.length; p++) {
            incident[src[p]][degree[src[p]]++] = p;
            if (src[p] != dst[p]) {
                incident[dst[p]][degree[dst[p]]++] = p;
            }
        }
    }

    public Relation getRelation() { return relation; }
    public boolean isStatic() { return isStatic; }

    @Override
    public boolean hasStaticMembership() { return isStatic; }
    int numPairs() { return src.length; }

    int[] incidentPairs(int e) { return incident[e]; }

    int lookup(int a, int b) {
        if (denseIndex != null) {
            if (a < 0 || a >= denseIndex.length || b < 0 || b >= denseIndex.length) {
                return -1;
            }
            final int[] row = denseIndex[a];
            return row == null ? -1 : row[b] - 1;
        }
        final Integer p = pairIndex.get(a, b);
        return p == null ? -1 : p;
    }

    // ----------------------------------------------------------------------------------------
    // Updates from the theory

    void collectOnExec(int e, int time, List<Edge> out) {
        for (int p : incident[e]) {
            final int a = atom[p];
            if (theory.isExecuted(src[p]) && theory.isExecuted(dst[p]) && (a < 0 || theory.atomValue(a) > 0)) {
                out.add(new Edge(src[p], dst[p], time, 0));
            }
        }
    }

    void collectOnAtomTrue(int p, int time, List<Edge> out) {
        if (theory.isExecuted(src[p]) && theory.isExecuted(dst[p])) {
            out.add(new Edge(src[p], dst[p], time, 0));
        }
    }

    // ----------------------------------------------------------------------------------------
    // Predicate interface

    @Override
    public boolean containsById(int a, int b) {
        if (graph.containsById(a, b)) {
            return true;
        }
        final int p = lookup(a, b);
        return p >= 0 && atom[p] < 0;
    }

    @Override
    public Edge get(Edge edge) {
        final Edge e = graph.get(edge);
        if (e != null) {
            return e;
        }
        final int p = lookup(edge.getFirst(), edge.getSecond());
        return (p >= 0 && atom[p] < 0) ? new Edge(edge.getFirst(), edge.getSecond()) : null;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Collection<Edge> forwardPropagate(CAATPredicate changedSource, Collection<? extends Derivable> added) {
        final List<Edge> changes = new ArrayList<>(added.size());
        for (Edge e : (Collection<Edge>) added) {
            if (graph.add(e)) {
                changes.add(e);
            }
        }
        return changes;
    }

    @Override
    public void backtrackTo(int time) {
        graph.backtrackTo(time);
    }

    @Override
    public void initializeToDomain(Domain<?> domain) {
        super.initializeToDomain(domain);
        graph.initializeToDomain(domain);
    }

    @Override
    public int size() { return graph.size(); }

    @Override
    public int size(int e, EdgeDirection dir) { return graph.size(e, dir); }

    @Override
    public boolean isEmpty() { return graph.isEmpty(); }

    @Override
    public Stream<Edge> edgeStream() { return graph.edgeStream(); }

    @Override
    public Stream<Edge> edgeStream(int e, EdgeDirection dir) { return graph.edgeStream(e, dir); }

    @Override
    public Iterator<Edge> edgeIterator() { return graph.edgeIterator(); }

    @Override
    public Iterator<Edge> edgeIterator(int e, EdgeDirection dir) { return graph.edgeIterator(e, dir); }

    @Override
    public String toString() { return getName(); }
}
