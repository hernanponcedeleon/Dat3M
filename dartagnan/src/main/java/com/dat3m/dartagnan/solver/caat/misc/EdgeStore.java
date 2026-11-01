package com.dat3m.dartagnan.solver.caat.misc;

import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;

import java.util.Arrays;

/*
    Stores edges by their endpoints for fast membership queries.
    For small domains, it uses dense rows (one lazily allocated row per source node),
    otherwise it falls back to a hash map.
 */
public final class EdgeStore {

    private static final int DENSE_THRESHOLD = 1024;

    private Edge[][] rows = new Edge[0][];
    private int domainSize = 0;
    private boolean dense = true;
    private PairMap<Edge> map;
    private int size = 0;

    public void initialize(int domainSize) {
        clear();
        this.domainSize = domainSize;
        this.dense = domainSize <= DENSE_THRESHOLD;
        if (dense) {
            if (rows.length < domainSize) {
                rows = Arrays.copyOf(rows, domainSize);
            }
            map = null;
        } else {
            rows = new Edge[0][];
            map = new PairMap<>(100);
        }
    }

    public int size() { return size; }

    public Edge get(int a, int b) {
        if (dense) {
            if (a >= domainSize || b >= domainSize) {
                return null;
            }
            final Edge[] row = rows[a];
            return row == null || b >= row.length ? null : row[b];
        }
        return map.get(a, b);
    }

    public boolean contains(int a, int b) {
        return get(a, b) != null;
    }

    // Returns true if the edge was added.
    public boolean add(Edge e) {
        final int a = e.getFirst();
        final int b = e.getSecond();
        if (dense) {
            Edge[] row = rows[a];
            if (row == null || row.length < domainSize) {
                // Rows are reused across domains (they are cleared), but may be too short for a larger domain.
                row = rows[a] = new Edge[domainSize];
            }
            if (row[b] != null) {
                return false;
            }
            row[b] = e;
            size++;
            return true;
        }
        if (map.putIfAbsent(a, b, e) != null) {
            return false;
        }
        size++;
        return true;
    }

    public void remove(int a, int b) {
        if (dense) {
            final Edge[] row = rows[a];
            if (row != null && b < row.length && row[b] != null) {
                row[b] = null;
                size--;
            }
        } else if (map.remove(a, b)) {
            size--;
        }
    }

    public void clear() {
        if (size == 0) {
            return;
        }
        if (dense) {
            for (Edge[] row : rows) {
                if (row != null) {
                    Arrays.fill(row, null);
                }
            }
        } else {
            map.clear();
        }
        size = 0;
    }
}
