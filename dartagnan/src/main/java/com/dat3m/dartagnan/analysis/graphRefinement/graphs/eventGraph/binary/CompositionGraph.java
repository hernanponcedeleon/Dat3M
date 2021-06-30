package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.utils.collections.SetUtil;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.*;

public class CompositionGraph extends MaterializedGraph {
    @Override
    public List<EventGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    protected EventGraph first;
    protected EventGraph second;

    public EventGraph getFirst() { return first; }
    public EventGraph getSecond() { return second; }

    public CompositionGraph(EventGraph first, EventGraph second) {
        this.first = first;
        this.second = second;
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        initialPopulation();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitComposition(this, data, context);
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        ArrayList<Edge> newEdges = new ArrayList<>();
        if (changedGraph == first) {
            // (A+R);B = A;B + R;B
            addedEdges.forEach(e -> updateFirst(e, newEdges));
        }
        if (changedGraph == second) {
            // A;(B+R) = A;B + A;R
            addedEdges.forEach(e -> updateSecond(e, newEdges));
        }
        // For A;A, we have the following:
        // (A+R);(A+R) = A;A + A;R + R;A + R;R = A;A + (A+R);R + R;(A+R)
        // So we add (A+R);R and R;(A+R), which is done by doing both update procedures
        return newEdges;
    }

    private void updateFirst(Edge a, Collection<Edge> addedEdges) {
        second.edgeStream(a.getSecond(), EdgeDirection.Outgoing)
                .map(b -> new Edge(a.getFirst(), b.getSecond(), a.getTime()))
                .filter(simpleGraph::add).forEach(addedEdges::add);
    }

    private void updateSecond(Edge b, Collection<Edge> addedEdges) {
        first.edgeStream(b.getFirst(), EdgeDirection.Ingoing)
                .map(a -> new Edge(a.getFirst(), b.getSecond(), b.getTime()))
                .filter(simpleGraph::add).forEach(addedEdges::add);
    }


    private void initialPopulation() {
        Set<Edge> fakeSet = SetUtil.fakeSet();
        if (first.getEstimatedSize() <= second.getEstimatedSize()) {
            first.edgeStream().forEach(a -> updateFirst(a, fakeSet));
        } else {
            second.edgeStream().forEach(b -> updateSecond(b, fakeSet));
        }
    }


}
