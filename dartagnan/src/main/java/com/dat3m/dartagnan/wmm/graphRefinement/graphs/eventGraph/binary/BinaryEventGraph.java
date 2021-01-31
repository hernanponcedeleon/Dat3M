package com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.DerivedEventGraph;
import com.dat3m.dartagnan.wmm.graphRefinement.graphs.eventGraph.EventGraph;

import java.util.Arrays;
import java.util.List;

public abstract class BinaryEventGraph extends DerivedEventGraph {
    @Override
    public List<EventGraph> getDependencies() {
        return Arrays.asList(first, second);
    }

    protected EventGraph first;
    protected EventGraph second;

    public EventGraph getFirst() { return first; }
    public EventGraph getSecond() { return second; }

    public BinaryEventGraph(EventGraph first, EventGraph second) {
        this.first = first;
        this.second = second;
    }

}
