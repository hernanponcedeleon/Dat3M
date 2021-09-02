package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.*;
import java.util.function.Predicate;

public class PathAlgorithm {

    private final static Queue<EventData> queue1 = new ArrayDeque<>();
    private final static HashSet<EventData> visited1 = new HashSet<>();
    private final static Map<EventData, Edge> parentMap1 = new HashMap<>();

    private final static Queue<EventData> queue2 = new ArrayDeque<>();
    private final static HashSet<EventData> visited2 = new HashSet<>();
    private final static Map<EventData, Edge> parentMap2 = new HashMap<>();


    /*
        This uses a bidirectional BFS to find a shortest path.
        A <filter> can be provided to skip certain edges during the search.
     */
    private static List<Edge> findShortestPathBiDirInternal(EventGraph graph, EventData start, EventData end,
                                                           Predicate<Edge> filter) {
        queue1.clear();
        queue2.clear();
        visited1.clear();;
        visited2.clear();
        parentMap1.clear();
        parentMap2.clear();

        queue1.add(start);
        queue2.add(end);
        boolean found = false;
        boolean doBFS1 = true;
        EventData cur = null;

        while (!queue1.isEmpty() || !queue2.isEmpty()) {
            // Forwards BFS
            if (doBFS1) {
                int curSize = queue1.size();
                while (curSize-- > 0 && !found) {
                    for (Edge next : graph.outEdges(queue1.poll())) {
                        if (!filter.test(next)) {
                            continue;
                        }

                        cur = next.getSecond();

                        if (cur == end || visited2.contains(cur)) {
                            found = true;
                            parentMap1.put(cur, next);
                            break;
                        } else if (visited1.add(cur)) {
                            parentMap1.put(cur, next);
                            queue1.add(cur);
                        }
                    }
                }
                if (found) {
                    break;
                }
                doBFS1 = false;
            } else {
                // Backward BFS
                int curSize = queue2.size();
                while (curSize-- > 0 && !found) {
                    for (Edge next : graph.inEdges(queue2.poll())) {
                        if (!filter.test(next)) {
                            continue;
                        }
                        cur = next.getFirst();

                        if (visited1.contains(cur)) {
                            found = true;
                            parentMap2.put(cur, next);
                            break;
                        } else if (visited2.add(cur)) {
                            parentMap2.put(cur, next);
                            queue2.add(cur);
                        }
                    }
                }
                if (found) {
                    break;
                }
                doBFS1 = true;
            }
        }

        if (!found || cur == null) {
            return Collections.emptyList();
        }

        //TODO: Find a way to efficiently get rid of the linked list
        // Maybe convert to an ArrayList when returning?
        LinkedList<Edge> path = new LinkedList<>();
        EventData e = cur;
        do {
            Edge backEdge = parentMap1.get(e);
            path.addFirst(backEdge);
            e = backEdge.getFirst();
        } while (!e.equals(start));

        e = cur;
        while (!e.equals(end)) {
            Edge forwardEdge = parentMap2.get(e);
            path.addLast(forwardEdge);
            e = forwardEdge.getSecond();
        }

        return path;
    }




    // =============================== Public Methods ===============================

    public static List<Edge> findShortestPath(EventGraph graph, EventData start, EventData end) {
        Predicate<Edge> alwaysTrueFilter = (edge -> true);
        return findShortestPathBiDirInternal(graph, start, end, alwaysTrueFilter);
    }


    //TODO: Check this version thoroughly (should we filter with '<' or '<=' ?)
    public static List<Edge> findShortestPath(EventGraph graph, EventData start, EventData end, int derivationBound) {
        Predicate<Edge> filter = (edge -> edge.getDerivationLength() < derivationBound);
        return findShortestPathBiDirInternal(graph, start, end, filter);
    }
}
