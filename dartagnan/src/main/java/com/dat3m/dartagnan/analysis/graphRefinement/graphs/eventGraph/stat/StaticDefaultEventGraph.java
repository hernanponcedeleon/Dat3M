package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.utils.Tuple;
import com.dat3m.dartagnan.wmm.utils.TupleSet;

import java.util.Iterator;

// Used for static relations that are not yet implemented explicitly
public class StaticDefaultEventGraph extends StaticEventGraph {
    private final Relation relation;
    private final SimpleGraph graph;

    public StaticDefaultEventGraph(Relation rel) {
        this.relation = rel;
        graph = new SimpleGraph();
    }

    @Override
    public boolean contains(Edge edge) {
        return graph.contains(edge);
    }



    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return graph.getMinSize(e, dir);
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
    public boolean contains(EventData a, EventData b) {
        return graph.contains(a, b);
    }


    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        graph.constructFromModel(context);
        TupleSet maxTupleSet = relation.getMaxTupleSet();
        for (Tuple tuple : relation.getEncodeTupleSet()) {
            // Edges are present IFF the tuple is part of <encodeTupleSet> AND <maxTupleSet>
            // (due to negated edges, the <encodeTupleSet> is not necessarily subset of <maxTupleSet>)
            if (!maxTupleSet.contains(tuple))
                continue;
            Edge e = context.getEdge(tuple);
            if (e != null) {
                graph.add(e);
            }
        }
        size = graph.size();
    }
}
