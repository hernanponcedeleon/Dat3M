package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.unary;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.DerivedEventGraph;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.EventGraph;

import java.util.Collections;
import java.util.List;

public abstract class UnaryGraph extends DerivedEventGraph {

    @Override
    public List<EventGraph> getDependencies() {
        return Collections.singletonList(inner);
    }

    protected EventGraph inner;

    public EventGraph getInner() {
        return inner;
    }

    public UnaryGraph(EventGraph inner) {
        this.inner = inner;
    }

}
