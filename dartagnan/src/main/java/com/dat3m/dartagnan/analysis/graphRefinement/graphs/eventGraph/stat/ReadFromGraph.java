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
        if (dir == EdgeDirection.Ingoing) {
            return  e.getReadFrom() == null ? 0 : 1;
        } else  {
            return e.isWrite() ? context.getWriteReadsMap().get(e).size() : 0;
        }
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        size = context.getReadWriteMap().size();
    }

    private Edge makeEdge(EventData a, EventData b) {
        return new Edge(a, b, 0);
    }

    @Override
    public Edge get(Edge edge) {
        return contains(edge) ? makeEdge(edge.getFirst(), edge.getSecond()) : null;
    }

    @Override
    public Stream<Edge> edgeStream() {
        return context.getReadWriteMap().entrySet().stream().map(x -> makeEdge(x.getValue(), x.getKey()));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        if (e.isWrite()) {
            return dir == EdgeDirection.Ingoing ? Stream.empty() :
                    context.getWriteReadsMap().get(e).stream().map(read -> makeEdge(e, read));
        } else if (e.isRead()) {
            return dir == EdgeDirection.Ingoing ?
                    Stream.of(new Edge(e.getReadFrom(), e)) : Stream.empty();
        }
        return Stream.empty();
    }
}
