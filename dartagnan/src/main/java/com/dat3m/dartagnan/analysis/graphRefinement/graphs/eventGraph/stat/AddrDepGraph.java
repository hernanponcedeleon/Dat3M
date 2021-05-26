package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.AbstractEventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.Iterator;

public class AddrDepGraph extends StaticEventGraph {



    @Override
    public boolean contains(EventData a, EventData b) {
        return false;
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return null;
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return null;
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return 0;
    }
}
