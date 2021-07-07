package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.stream.Stream;

public class EmptyGraph extends StaticEventGraph {

    @Override
    public boolean contains(Edge edge) {
        return false;
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return false;
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return 0;
    }

    @Override
    public Stream<Edge> edgeStream() {
        return Stream.empty();
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        return Stream.empty();
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        size = 0;
    }

}
