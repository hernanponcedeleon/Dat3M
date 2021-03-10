package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.verification.model.ModelContext;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.collections.SetUtil;
import com.dat3m.dartagnan.utils.timeable.Timestamp;

import java.util.*;

public class CompositionGraph extends BinaryEventGraph {

    private final SimpleGraph graph;

    public CompositionGraph(EventGraph first, EventGraph second) {
        super(first, second);
        graph = new SimpleGraph();
    }

    @Override
    public boolean contains(Edge edge) {
        return graph.contains(edge);
    }

    @Override
    public Timestamp getTime(Edge edge) {
        return graph.getTime(edge);
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

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        ArrayList<Edge> newEdges = new ArrayList<>();
        if (changedGraph == first) {
            for (Edge e : addedEdges) {
                updateFirst(e, newEdges);
            }
        } else if (changedGraph == second) {
            for (Edge e : addedEdges) {
                updateSecond(e, newEdges);
            }
        }
        // TODO: case first == second == changedGraph
        return newEdges;
    }

    private void updateSecond(Edge b, Collection<Edge> addedEdges) {
        for (Edge a : first.inEdges(b.getFirst())) {
            Edge edge = new Edge(a.getFirst(), b.getSecond(), b.getTime());
            if (graph.add(edge))
                addedEdges.add(edge);
        }
    }

    private void updateFirst(Edge a, Collection<Edge> addedEdges) {
        for (Edge b : second.outEdges(a.getSecond())) {
            Edge edge = new Edge(a.getFirst(), b.getSecond(), a.getTime());
            if (graph.add(edge))
                addedEdges.add(edge);
        }
    }

    private void initialPopulation() {

        Set<Edge> fakeSet = SetUtil.fakeSet();
        if (first.getEstimatedSize() <= second.getEstimatedSize()) {
            for (Edge a : first.edges()) {
                updateFirst(a, fakeSet);
            }
        } else {
            for (Edge b : second.edges()) {
                updateSecond(b, fakeSet);
            }
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
    public Conjunction<CoreLiteral> computeReason(Edge edge) {
         if (!contains(edge))
             return Conjunction.FALSE;

         if (first.getEstimatedSize(edge.getFirst(), EdgeDirection.Outgoing)
                 <= second.getEstimatedSize(edge.getSecond(), EdgeDirection.Ingoing)) {
             for (Edge a : first.outEdges(edge.getFirst())) {
                 Edge b = new Edge(a.getSecond(), edge.getSecond());
                 if (second.contains(b)) {
                     return first.computeReason(a).and(second.computeReason(b));
                 }
             }
         } else {
             for (Edge b : second.inEdges(edge.getSecond())) {
                 Edge a = new Edge(edge.getFirst(), b.getFirst());
                 if (first.contains(a)) {
                     return first.computeReason(a).and(second.computeReason(b));
                 }
             }
         }

         // This point should not be reachable
        throw new IllegalStateException("This exception should not be reachable.");
         //return Conjunction.FALSE;
    }


}
