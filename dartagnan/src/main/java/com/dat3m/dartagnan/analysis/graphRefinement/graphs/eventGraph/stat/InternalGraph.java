package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Stream;

public class InternalGraph extends StaticEventGraph {
    private Map<Thread, List<EventData>> threadEventsMap;

    @Override
    public boolean contains(Edge edge) {
        return edge.isInternal();
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return a.getThread() == b.getThread();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return threadEventsMap.get(e.getThread()).size();
    }

    @Override
    public Stream<Edge> edgeStream() {
        return model.getEventList().stream().flatMap(e -> edgeStream(e, EdgeDirection.Outgoing));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        Function<EventData, Edge> edgeMapping = dir == EdgeDirection.Outgoing ?
                (x -> new Edge(e, x)) : (x -> new Edge(x, e));

        return threadEventsMap.get(e.getThread()).stream().map(edgeMapping);
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        threadEventsMap = model.getThreadEventsMap();
        size = threadEventsMap.values().stream().mapToInt(x -> x.size() * x.size()).sum();
    }

}
