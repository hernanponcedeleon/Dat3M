package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.binary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.AbstractEventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;

import java.util.Arrays;
import java.util.List;

// TODO: This class is outdated
public abstract class BinaryEventGraph extends AbstractEventGraph {
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
