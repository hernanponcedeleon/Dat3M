package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.wmm.graphRefinement.ModelContext;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.Edge;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.EventData;
import com.dat3m.dartagnan.wmm.graphRefinement.decoration.RelationData;
import com.dat3m.dartagnan.wmm.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.SimpleGraph;
import com.dat3m.dartagnan.wmm.utils.Tuple;

import java.util.Iterator;

// Used for static relations that are not yet implemented explicitly
public class StaticDefaultEventGraph extends StaticEventGraph {
    private final RelationData relationData;
    private final SimpleGraph graph;

    public StaticDefaultEventGraph(RelationData rel) {
        this.relationData = rel;
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
    public void initialize(ModelContext context) {
        super.initialize(context);
        graph.initialize(context);
        for (Tuple tuple : relationData.getWrappedRelation().getEncodeTupleSet()) {
            // Edges are present IFF the tuple is part of <encodeTupleSet> AND <maxTupleSet>
            // (due to negated edges, the <encodeTupleSet> is not necessarily subset of <maxTupleSet>)
            if (!relationData.getWrappedRelation().getMaxTupleSet().contains(tuple))
                continue;
            Edge e = context.getEdge(tuple);
            if (e != null) {
                graph.add(e);
            }
            /*if (context.eventExists(tuple.getFirst()) && context.eventExists(tuple.getSecond())) {
                graph.add(context.getEdge(tuple));
            }*/
        }
    }
}
