package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.basic;

import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.ReasoningEngine;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.AbstractEventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.relation.Relation;

import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

//A non-transitive version of coherence.
// The fact that it is coherence is only relevant for <computeReason>
public class CoherenceGraph extends AbstractEventGraph {

    private final SimpleGraph graph;
    private Relation co;

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.emptyList();
    }

    public CoherenceGraph() {
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
    public boolean contains(EventData a, EventData b) {
        return graph.contains(a, b);
    }

    @Override
    public Timestamp getTime(EventData a, EventData b) {
        return graph.getTime(a, b);
    }


    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        graph.constructFromModel(context);
        co = context.getMemoryModel().getRelationRepository().getRelation("co");
    }

    @Override
    public void backtrack() {
        graph.backtrack();
    }

    @Override
    public Collection<Edge> forwardPropagate(EventGraph changedGraph, Collection<Edge> addedEdges) {
        return forwardPropagate(addedEdges);
    }

    public Collection<Edge> forwardPropagate(Collection<Edge> addedEdges) {
        return addedEdges.stream().filter(graph::add).collect(Collectors.toList());
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
    public Conjunction<CoreLiteral> computeReason(Edge edge, ReasoningEngine reasEngine) {
        if (!contains(edge))
            return Conjunction.FALSE;
        Conjunction<CoreLiteral> reason = reasEngine.tryGetStaticReason(this, edge);
        if (reason != null) {
            return reason;
        }
        return reasEngine.getCoherenceReason(edge);

        // The second condition is test code
        /*if (edge.getFirst().isInit() || co.getMinTupleSet().contains(edge.toTuple())) {
            return new Conjunction<>(new EventLiteral(edge.getFirst()), new EventLiteral(edge.getSecond()));
        } else {
            return new Conjunction<>(new CoLiteral(edge), new LocLiteral(edge));
        }*/
    }
}
