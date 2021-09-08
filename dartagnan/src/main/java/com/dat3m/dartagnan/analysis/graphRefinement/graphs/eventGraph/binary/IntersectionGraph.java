package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.*;

// A materialized Intersection Graph.
// This seems to be more efficient than the virtualized IntersectionGraph we used before.
public class IntersectionGraph extends MaterializedGraph {

    private final EventGraph first;
    private final EventGraph second;

    @Override
    public List<? extends EventGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    public EventGraph getFirst() { return first; }
    public EventGraph getSecond() { return second; }

    public IntersectionGraph(EventGraph first, EventGraph second) {
        this.first = first;
        this.second = second;
    }

    // Note: The derived edge has the timestamp of edge <a>
    private Edge derive(Edge a, Edge b) {
        return a.with(Math.max(a.getDerivationLength(), b.getDerivationLength()) + 1);
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);

        if (first.getEstimatedSize() < second.getEstimatedSize()) {
            //TODO: Using optionals makes the code look nicer, but the performance might degrade
            // because this will probably end up creating a lot of unnecessary closures.
            // We need to benchmark this at some point!
            for (Edge e1 : first.edges()) {
                second.get(e1).ifPresent(e2 -> simpleGraph.add(derive(e1, e2)));
            }
        } else {
            for (Edge e2 : second.edges()) {
                first.get(e2).ifPresent(e1 -> simpleGraph.add(derive(e1, e2)));
            }
        }
    }


    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == first || changedGraph == second) {
            EventGraph other = changedGraph == first ? second : first;

            List<Edge> newlyAdded = new ArrayList<>();
            for (Edge e1 : addedEdges) {
                Optional<Edge> e2 = other.get(e1);
                if (e2.isPresent()) {
                    Edge e = derive(e1, e2.get());
                    simpleGraph.add(e);
                    newlyAdded.add(e);
                }
            }
            addedEdges = newlyAdded;
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitIntersection(this, data, context);
    }

}