package com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.utils;

import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.analysis.saturation.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.*;
import java.util.function.Predicate;

public class PathAlgorithm {

    private final static Queue<EventData> queue1 = new ArrayDeque<>();
    private final static Queue<EventData> queue2 = new ArrayDeque<>();

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
    private static List<Edge> findShortestPathBiDirInternal(RelationGraph graph, EventData start, EventData end,
                                                            Predicate<Edge> filter) {
        queue1.clear();
        queue2.clear();

        Arrays.fill(parentMap1, null);
        System.arraycopy(parentMap1, 0, parentMap2, 0, Math.min(parentMap1.length, parentMap2.length));

        queue1.add(start);
        queue2.add(end);
        boolean found = false;
        boolean doForwardBFS = true;
        EventData cur = null;

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
                        int id = cur.getId();

                        if (cur == end || parentMap2[id] != null) {
                            parentMap1[id] = next;
                            found = true;
                            break;
                        } else if (parentMap1[id] == null) {
                            parentMap1[id] = next;
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
                        int id = cur.getId();

                        if (parentMap1[id] != null) {
                            parentMap2[id] = next;
                            found = true;
                            break;
                        } else if (parentMap2[id] == null) {
                            parentMap2[id] = next;
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

        //TODO: Find a way to efficiently get rid of the linked list
        // Maybe convert to an ArrayList when returning?
        LinkedList<Edge> path = new LinkedList<>();
        EventData e = cur;
        do {
            Edge backEdge = parentMap1[e.getId()];
            path.addFirst(backEdge);
            e = backEdge.getFirst();
        } while (!e.equals(start));

        e = cur;
        while (!e.equals(end)) {
            Edge forwardEdge = parentMap2[e.getId()];
            path.addLast(forwardEdge);
            e = forwardEdge.getSecond();
        }

        return path;
    }




    // =============================== Public Methods ===============================

    public static List<Edge> findShortestPath(RelationGraph graph, EventData start, EventData end) {
        Predicate<Edge> alwaysTrueFilter = (edge -> true);
        return findShortestPathBiDirInternal(graph, start, end, alwaysTrueFilter);
    }


    //TODO: Check this version thoroughly (should we filter with '<' or '<=' ?)
    public static List<Edge> findShortestPath(RelationGraph graph, EventData start, EventData end, int derivationBound) {
        Predicate<Edge> filter = (edge -> edge.getDerivationLength() < derivationBound);
        return findShortestPathBiDirInternal(graph, start, end, filter);
    }
}
