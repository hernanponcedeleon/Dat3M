package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.GraphDerivable;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.OneTimeIterable;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;

import java.util.*;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

public interface EventGraph extends GraphDerivable, Set<Edge> {

    boolean contains(EventData a, EventData b);
    Timestamp getTime(EventData a, EventData b);

    Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges);

    void constructFromModel(ExecutionModel context);
    void backtrack();

    int getMinSize();
    int getMinSize(EventData e, EdgeDirection dir);
    int getMaxSize();
    int getMaxSize(EventData e, EdgeDirection dir);

    Iterator<Edge> edgeIterator();
    Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir);

    Conjunction<CoreLiteral> computeReason(Edge edge);


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
        //TODO: Implement bidirectional BFS
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
}
