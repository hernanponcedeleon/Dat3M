package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.google.common.collect.Lists;

import java.util.*;

public class PathAlgorithm {

    // Finds a shortest path between <start> and <end>. In case of <start> == <end>, a shortest cycle will
    // be computed.
    public static List<Edge> findShortestPath(EventGraph graph, EventData start, EventData end) {
        // A BFS search for a shortest path.
        Queue<EventData> queue = new ArrayDeque<>();
        HashSet<EventData> visited = new HashSet<>();
        Map<EventData, Edge> parentMap = new HashMap<>();

        queue.add(start);
        boolean found = false;

        while (!queue.isEmpty() && !found) {
            EventData cur = queue.poll();
            for (Edge next : graph.outEdges(cur)){
                EventData e = next.getSecond();

                if (e == end) {
                    found = true;
                    parentMap.put(e, next);
                    break;
                }

                if(!visited.contains(e)) {
                    parentMap.put(e, next);
                    visited.add(e);
                    queue.add(e);
                }
            }
        }
        if (!found) {
            return Collections.emptyList();
        }

        ArrayList<Edge> path = new ArrayList<>();
        do {
            Edge backEdge = parentMap.get(end);
            path.add(backEdge);
            end = backEdge.getFirst();
        } while (!end.equals(start));

        return Lists.reverse(path);
    }

    // Bidirectional ShortestPath
    public static List<Edge> findShortestPathBiDir(EventGraph graph, EventData start, EventData end) {
        // A Bidirectional BFS search for a shortest path.
        Queue<EventData> queue1 = new ArrayDeque<>();
        HashSet<EventData> visited1 = new HashSet<>();
        Map<EventData, Edge> parentMap1 = new HashMap<>();

        Queue<EventData> queue2 = new ArrayDeque<>();
        HashSet<EventData> visited2 = new HashSet<>();
        Map<EventData, Edge> parentMap2 = new HashMap<>();

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
                        cur = next.getSecond();

                        if (cur == end || visited2.contains(cur)) {
                            found = true;
                            parentMap1.put(cur, next);
                            break;
                        }

                        if (!visited1.contains(cur)) {
                            parentMap1.put(cur, next);
                            visited1.add(cur);
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
                        cur = next.getFirst();

                        if (visited1.contains(cur)) {
                            found = true;
                            parentMap2.put(cur, next);
                            break;
                        }
                        if (!visited2.contains(cur)) {
                            parentMap2.put(cur, next);
                            visited2.add(cur);
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


    //TODO: Check this code thoroughly
    public static List<Edge> findShortestPathBiDir(EventGraph graph, EventData start, EventData end, int derivationBound) {
        // A Bidirectional BFS search for a shortest path.
        Queue<EventData> queue1 = new ArrayDeque<>();
        HashSet<EventData> visited1 = new HashSet<>();
        Map<EventData, Edge> parentMap1 = new HashMap<>();

        Queue<EventData> queue2 = new ArrayDeque<>();
        HashSet<EventData> visited2 = new HashSet<>();
        Map<EventData, Edge> parentMap2 = new HashMap<>();

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
                        if (next.getDerivationLength() >= derivationBound) {
                            continue;
                        }
                        cur = next.getSecond();

                        if (cur == end || visited2.contains(cur)) {
                            found = true;
                            parentMap1.put(cur, next);
                            break;
                        }

                        if (!visited1.contains(cur)) {
                            parentMap1.put(cur, next);
                            visited1.add(cur);
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
                        if (next.getDerivationLength() >= derivationBound) {
                            continue;
                        }
                        cur = next.getFirst();

                        if (visited1.contains(cur)) {
                            found = true;
                            parentMap2.put(cur, next);
                            break;
                        }
                        if (!visited2.contains(cur)) {
                            parentMap2.put(cur, next);
                            visited2.add(cur);
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
}
