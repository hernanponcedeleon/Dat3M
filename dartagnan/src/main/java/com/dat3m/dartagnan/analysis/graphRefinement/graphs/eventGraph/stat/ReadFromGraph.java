package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.stream.Stream;

public class ReadFromGraph extends StaticEventGraph {

    @Override
    public boolean contains(Edge edge) {
        return contains(edge.getFirst(), edge.getSecond());
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return b.getReadFrom() == a;
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        if (dir == EdgeDirection.INGOING) {
            return  e.getReadFrom() == null ? 0 : 1;
        } else  {
            return e.isWrite() ? model.getWriteReadsMap().get(e).size() : 0;
        }
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        size = model.getReadWriteMap().size();
    }

    private Edge makeEdge(EventData a, EventData b) {
        return new Edge(a, b, 0);
    }

    @Override
    public Stream<Edge> edgeStream() {
        return model.getReadWriteMap().entrySet().stream().map(x -> makeEdge(x.getValue(), x.getKey()));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        if (e.isWrite()) {
            return dir == EdgeDirection.INGOING ? Stream.empty() :
                    model.getWriteReadsMap().get(e).stream().map(read -> makeEdge(e, read));
        } else if (e.isRead()) {
            return dir == EdgeDirection.INGOING ?
                    Stream.of(new Edge(e.getReadFrom(), e)) : Stream.empty();
        }
        return Stream.empty();
    }
}
