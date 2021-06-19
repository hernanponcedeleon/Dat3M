package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Iterator;

// A materalized Union Graph. This seems to be more efficient than the virtualized UnionGraph
public class MatUnionGraph extends BinaryEventGraph {

    private final SimpleGraph simpleGraph = new SimpleGraph();

    public MatUnionGraph(EventGraph first, EventGraph second) {
        super(first, second);
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        simpleGraph.constructFromModel(context);

        simpleGraph.addAll(first);
        simpleGraph.addAll(second);
    }

    @Override
    public void backtrack() {
        simpleGraph.backtrack();
    }

    @Override
    public boolean contains(Edge edge) {
        return simpleGraph.contains(edge);
    }


    @Override
    public boolean contains(EventData a, EventData b) {
        return simpleGraph.contains(a, b);
    }

    @Override
    public Timestamp getTime(Edge edge) {
        return simpleGraph.getTime(edge);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return simpleGraph.getTime(a, b);
    }

    @Override
    public int getMinSize() {
        return simpleGraph.getMinSize();
    }

    @Override
    public int getMaxSize() {
        return simpleGraph.getMaxSize();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return simpleGraph.getMinSize(e, dir);
    }

    @Override
    public int getMaxSize(EventData e, EdgeDirection dir) {
        return simpleGraph.getMaxSize(e, dir);
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return simpleGraph.edgeIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return simpleGraph.edgeIterator(e, dir);
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        if (changedGraph == first || changedGraph == second) {
            addedEdges.removeIf(edge -> !simpleGraph.add(edge));
        } else {
            addedEdges.clear();
        }
        return addedEdges;
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge) {
        if (!contains(edge)) {
            return Conjunction.FALSE;
        }
        return first.contains(edge) ? first.computeReason(edge) : second.computeReason(edge);
    }

}