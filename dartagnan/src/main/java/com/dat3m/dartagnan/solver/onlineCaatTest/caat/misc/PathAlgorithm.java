package com.dat3m.dartagnan.solver.onlineCaatTest.caat.misc;


import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.onlineCaatTest.caat.predicates.relationGraphs.RelationGraph;

import java.util.*;
import java.util.function.Predicate;

public class PathAlgorithm {

    //TODO: We need custom data datastructures that work with primitive integers
    private final static Queue<Integer> queue1 = new ArrayDeque<>();
    private final static Queue<Integer> queue2 = new ArrayDeque<>();

    private static Edge[] parentMap1 = new Edge[0];
    private static Edge[] parentMap2 = new Edge[0];

    public static void ensureCapacity(int capacity) {
        if (capacity <= parentMap1.length) {
            return;
        }

        final int newCapacity = capacity + 20;
        parentMap1 = Arrays.copyOf(parentMap1, newCapacity);
        parentMap2 = Arrays.copyOf(parentMap2, newCapacity);
    }


    /*
        This uses a bidirectional BFS to find a shortest path.
        A <filter> can be provided to skip certain edges during the search.
     */
    public static List<Edge> findShortestPath(RelationGraph graph, int start, int end,
                                              Predicate<Edge> filter) {
        queue1.clear();
        queue2.clear();

        Arrays.fill(parentMap1, null);
        System.arraycopy(parentMap1, 0, parentMap2, 0, Math.min(parentMap1.length, parentMap2.length));

        queue1.add(start);
        queue2.add(end);
        boolean found = false;
        boolean doForwardBFS = true;
        int cur = -1;

        while (!found && (!queue1.isEmpty() || !queue2.isEmpty())) {
            if (doForwardBFS) {
                // Forward BFS
                int curSize = queue1.size();
                while (curSize-- > 0 && !found) {
                    for (Edge next : graph.outEdges(queue1.poll())) {
                        if (!filter.test(next)) {
                            continue;
                        }

                        cur = next.getSecond();

                        if (cur == end || parentMap2[cur] != null) {
                            parentMap1[cur] = next;
                            found = true;
                            break;
                        } else if (parentMap1[cur] == null) {
                            parentMap1[cur] = next;
                            queue1.add(cur);
                        }
                    }
                }
                doForwardBFS = false;
            } else {
                // Backward BFS
                int curSize = queue2.size();
                while (curSize-- > 0 && !found) {
                    for (Edge next : graph.inEdges(queue2.poll())) {
                        if (!filter.test(next)) {
                            continue;
                        }
                        cur = next.getFirst();

                        if (parentMap1[cur] != null) {
                            parentMap2[cur] = next;
                            found = true;
                            break;
                        } else if (parentMap2[cur] == null) {
                            parentMap2[cur] = next;
                            queue2.add(cur);
                        }
                    }
                }
                doForwardBFS = true;
            }
        }

        if (!found) {
            return Collections.emptyList();
        }

        LinkedList<Edge> path = new LinkedList<>();
        int e = cur;
        do {
            Edge backEdge = parentMap1[e];
            path.addFirst(backEdge);
            e = backEdge.getFirst();
        } while (e != start);

        e = cur;
        while (e != end) {
            Edge forwardEdge = parentMap2[e];
            path.addLast(forwardEdge);
            e = forwardEdge.getSecond();
        }

        return path;
    }




    // =============================== Public Methods ===============================

    public static List<Edge> findShortestPath(RelationGraph graph, int start, int end) {
        Predicate<Edge> alwaysTrueFilter = (edge -> true);
        return findShortestPath(graph, start, end, alwaysTrueFilter);
    }


    public static List<Edge> findShortestPath(RelationGraph graph, int start, int end, int derivationBound) {
        Predicate<Edge> filter = (edge -> edge.getDerivationLength() <= derivationBound);
        return findShortestPath(graph, start, end, filter);
    }
}
