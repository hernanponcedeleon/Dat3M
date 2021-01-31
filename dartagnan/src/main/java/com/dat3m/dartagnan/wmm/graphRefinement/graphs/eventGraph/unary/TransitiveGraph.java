package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.wmm.graphRefinement.ModelContext;
import com.dat3m.dartagnan.wmm.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.wmm.graphRefinement.util.SetUtil;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.timeable.Timestamp;

import java.util.*;

public class TransitiveGraph extends UnaryGraph {

    //private TimedEdgeContainer edges;
    private final SimpleGraph graph;

    public TransitiveGraph(EventGraph inner) {
        super(inner);
        graph = new SimpleGraph();
    }

    @Override
    public boolean contains(Edge edge) {
        return graph.contains(edge);
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return graph.contains(a, b);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return graph.getTime(a, b);
    }


    @Override
    public Timestamp getTime(Edge edge) {
        return graph.getTime(edge);
    }

    @Override
    public int getMinSize() {
        return graph.getMinSize();
    }

    @Override
    public int getMaxSize() {
        return graph.getMaxSize();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return graph.getMinSize(e, dir);
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return graph.getMaxSize(e, dir);
    }

    @Override
    public int getEstimatedSize(EventData e, EdgeDirection dir) {
        return graph.getEstimatedSize(e, dir);
    }

    @Override
    public void initialize(ModelContext context) {
        super.initialize(context);
        graph.initialize(context);
        initialPopulation();
    }

    @Override
    public void backtrack() {
        graph.backtrack();
    }

    private void initialPopulation() {
        //TODO: This is inefficient for many edges (the likely default case!)
        Set<Edge> fakeSet = SetUtil.fakeSet();
        for (Edge e : inner.edges()) {
            updateEdgeRecursive(e, fakeSet);
        }
    }

    private void updateEdgeRecursive(Edge edge, Set<Edge> addedEdges) {
        if (!graph.add(edge))
            return;
        addedEdges.add(edge);
        for (Edge inEdge : inEdges(edge.getFirst())) {
            Edge newEdge = new Edge(inEdge.getFirst(), edge.getSecond(), edge.getTime());
            if (graph.add(newEdge)) {
                addedEdges.add(newEdge);
                for (Edge outEdge : outEdges(edge.getSecond())) {
                    newEdge = new Edge(inEdge.getFirst(), outEdge.getSecond(), edge.getTime());
                    if (graph.add(newEdge))
                        addedEdges.add(newEdge);
                }
            }
        }

        for (Edge outEdge : outEdges(edge.getSecond())) {
            Edge newEdge = new Edge(edge.getFirst(), outEdge.getSecond(), edge.getTime());
            if (graph.add(newEdge))
                addedEdges.add(newEdge);
        }
    }



    @Override
    public Iterator<Edge> edgeIterator() {
        return graph.edgeIterator();
    }


    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return graph.edgeIterator(e, dir);
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        Set<Edge> newEdges = new HashSet<>();
        if (changedGraph == inner) {
            for (Edge e : addedEdges) {
                updateEdgeRecursive(e, newEdges);
                /*if (edges.add(e)) {
                    newEdges.add(e);
                    updateEdgeRecursive(e, newEdges);
                }*/
            }
        }
        return newEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge) {
         if (!contains(edge))
             return Conjunction.FALSE;
         else if (inner.contains(edge))
             return inner.computeReason(edge);

        Conjunction<CoreLiteral> result = Conjunction.TRUE;
        for (Edge innerEdge : findShortestPathInternal(edge.getFirst(), edge.getSecond())) {
            result = result.and(inner.computeReason(innerEdge));
        }
        return result;
    }


    Queue<EventData> queue = new ArrayDeque<>();
    HashSet<EventData> visited = new HashSet<>();
    Map<EventData, Edge> parentMap = new HashMap<>();
    private List<Edge> findShortestPathInternal(EventData start, EventData end) {
        // A BFS search for a shortest path.
        //TODO: Implement bidirectional BFS
        queue.clear();
        visited.clear();
        parentMap.clear();

        queue.add(start);
        boolean found = false;

        while (!queue.isEmpty() && !found) {
            EventData cur = queue.poll();
            for (Edge next : inner.outEdges(cur)){
                EventData e = next.getSecond();

                if (e == end) {
                    found = true;
                    parentMap.put(e, next);
                    break;
                }

                if(!visited.contains(e) && graph.contains(e, end)) {
                    parentMap.put(e, next);
                    visited.add(e);
                    queue.add(e);
                }
            }
        }
        if (!found)
            throw new RuntimeException("This should never happen");

        ArrayList<Edge> path = new ArrayList<>();
        do {
            Edge backEdge = parentMap.get(end);
            path.add(backEdge);
            end = backEdge.getFirst();
        } while (!end.equals(start));

        return path;
    }

}
