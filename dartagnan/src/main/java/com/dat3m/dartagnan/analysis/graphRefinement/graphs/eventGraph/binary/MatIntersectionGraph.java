package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.MaterializedGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

// A materialized Intersection Graph.
// This seems to be more efficient than the virtualized IntersectionGraph we used before.
public class MatIntersectionGraph extends MaterializedGraph {

    private final EventGraph first;
    private final EventGraph second;

    @Override
    public List<? extends EventGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    public EventGraph getFirst() { return first; }
    public EventGraph getSecond() { return second; }

    public MatIntersectionGraph(EventGraph first, EventGraph second) {
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
            for (Edge e1 : first.edges()) {
                Edge e2 = second.get(e1);
                if (e2 != null) {
                    simpleGraph.add(derive(e1, e2));
                }
            }
            //simpleGraph.addAll(Sets.intersection(first.setView(), second.setView()));
        } else {
            for (Edge e2 : second.edges()) {
                Edge e1 = first.get(e2);
                if (e1 != null) {
                    simpleGraph.add(derive(e2, e1));
                }
            }
            //simpleGraph.addAll(Sets.intersection(second.setView(), first.setView()));
        }
    }


    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == first || changedGraph == second) {
            EventGraph other = changedGraph == first ? second : first;

            List<Edge> newlyAdded = new ArrayList<>();
            for (Edge e1 : addedEdges) {
                Edge e2 = other.get(e1);
                if (e2 != null) {
                    Edge e = derive(e1, e2);
                    simpleGraph.add(e);
                    newlyAdded.add(e);
                }
            }
            /*addedEdges.removeIf(x -> !other.contains(x));
            simpleGraph.addAll(addedEdges);*/
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