package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.ReasoningEngine;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.GraphDerivable;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.OneTimeIterable;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.*;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public interface EventGraph extends GraphDerivable, Set<Edge> {


    boolean contains(EventData a, EventData b);
    Timestamp getTime(EventData a, EventData b);

    Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges);

    void constructFromModel(ExecutionModel context);
    ExecutionModel getModel();
    void backtrack();

    int getMinSize();
    int getMinSize(EventData e, EdgeDirection dir);
    int getMaxSize();
    int getMaxSize(EventData e, EdgeDirection dir);

    Iterator<Edge> edgeIterator();
    Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir);

    Conjunction<CoreLiteral> computeReason(Edge edge, ReasoningEngine reasEngine);


    void setName(String name);
    String getName();


    default boolean contains(Edge edge) { return contains(edge.getFirst(), edge.getSecond()); }
    default Timestamp getTime(Edge edge) { return getTime(edge.getFirst(), edge.getSecond()); }

    default int getEstimatedSize() { return (getMinSize() + getMaxSize()) >> 1; }
    default int getEstimatedSize(EventData e, EdgeDirection dir) {
        return (getMinSize(e, dir) + getMaxSize(e, dir)) >> 1;
    }

    default Iterable<Edge> edges() { return new OneTimeIterable<>(edgeIterator()); }
    default Iterable<Edge> edges(EventData e, EdgeDirection dir)
    { return  new OneTimeIterable<>(edgeIterator(e, dir)); }

    default Iterator<Edge> inEdgeIterator(EventData e) { return edgeIterator(e, EdgeDirection.Ingoing); }
    default Iterator<Edge> outEdgeIterator(EventData e) { return edgeIterator(e, EdgeDirection.Outgoing); }

    default Iterable<Edge> inEdges(EventData e) { return new OneTimeIterable<>(inEdgeIterator(e)); }
    default Iterable<Edge> outEdges(EventData e) {  return new OneTimeIterable<>(outEdgeIterator(e)); }


    default Stream<Edge> edgeStream() {
        Iterable<Edge> iterable = this::edgeIterator;
        return StreamSupport.stream(iterable.spliterator(), false);
    }

    default Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        Iterable<Edge> iterable = () -> edgeIterator(e, dir);
        return StreamSupport.stream(iterable.spliterator(), false);
    }



    // Finds a shortest path between <start> and <end>. In case of <start> == <end>, a shortest cycle will
    // be computed.
    default List<Edge> findShortestPath(EventData start, EventData end) {
        // A BFS search for a shortest path.
        Queue<EventData> queue = new ArrayDeque<>();
        HashSet<EventData> visited = new HashSet<>();
        Map<EventData, Edge> parentMap = new HashMap<>();

        queue.add(start);
        boolean found = false;

        while (!queue.isEmpty() && !found) {
            EventData cur = queue.poll();
            for (Edge next : this.outEdges(cur)){
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

        return path;
    }

    // Bidirectional ShortestPath
    default List<Edge> findShortestPathBiDir(EventData start, EventData end) {
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
                    for (Edge next : this.outEdges(queue1.poll())) {
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
                    for (Edge next : this.inEdges(queue2.poll())) {
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

        ArrayList<Edge> path = new ArrayList<>();
        EventData e = cur;
        do {
            Edge backEdge = parentMap1.get(e);
            path.add(backEdge);
            e = backEdge.getFirst();
        } while (!e.equals(start));

        e = cur;
        while (!e.equals(end)) {
            Edge forwardEdge = parentMap2.get(e);
            path.add(forwardEdge);
            e = forwardEdge.getSecond();
        }

        /*do {
            Edge forwardEdge = parentMap2.get(e);
            path.add(forwardEdge);
            e = forwardEdge.getSecond();
        } while (!e.equals(end));*/

        return path;
    }
}
