package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.binary;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.AbstractRelationGraph;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.RelationGraph;
import com.dat3m.dartagnan.solver.caat.util.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

//TODO: This class is not up-to-date with the new derivation length.
// However, this doesn't cause any issues as we do not support differences in recursion.
public class DifferenceGraph extends AbstractRelationGraph {

    private final RelationGraph first;
    private final RelationGraph second;

    @Override
    public List<? extends RelationGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    public RelationGraph getFirst() { return first; }
    public RelationGraph getSecond() { return second; }

    public DifferenceGraph(RelationGraph first, RelationGraph second) {
        this.first = first;
        this.second = second;
    }

    @Override
    public Optional<Edge> get(Edge edge) {
        return second.contains(edge) ? Optional.empty() : first.get(edge);
    }

    @Override
    public boolean contains(Edge edge) {
        return first.contains(edge) && !second.contains(edge);
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return first.contains(a, b) && !second.contains(a, b);
    }

    @Override
    public int getMinSize() {
        return Math.max(0, first.getMinSize() - second.getMaxSize());
    }

    @Override
    public int getMaxSize() {
        return first.getMaxSize();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return Math.max(0, first.getMinSize(e, dir) - second.getMaxSize(e, dir));
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return first.getMaxSize(e, dir);
    }

    @Override
    public Stream<Edge> edgeStream() {
        return first.edgeStream().filter(edge -> !second.contains(edge));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        return first.edgeStream(e, dir).filter(edge -> !second.contains(edge));
    }

    @Override
    public Collection<Edge> forwardPropagate(RelationGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == first) {
            return addedEdges.stream().filter(e -> !second.contains(e)).collect(Collectors.toList());
        } else if (changedGraph == second) {
            throw new IllegalStateException("Non-static relations on the right hand side of differences are invalid.");
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitDifference(this, data, context);
    }

}
