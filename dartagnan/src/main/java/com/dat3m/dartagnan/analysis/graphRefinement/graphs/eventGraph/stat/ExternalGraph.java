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

//TODO: The iteration fails, if there exists a thread without any events!
public class ExternalGraph extends StaticEventGraph {
    private Map<Thread, List<EventData>> threadEventsMap;

    @Override
    public boolean contains(Edge edge) {
        return edge.isCrossEdge();
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return a.getThread() != b.getThread();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        return context.getEventList().size() - context.getThreadEventsMap().get(e.getThread()).size();
    }

    @Override
    public Stream<Edge> edgeStream() {
        return context.getEventList().stream().flatMap(e -> edgeStream(e, EdgeDirection.Outgoing));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        Function<EventData, Edge> edgeMapping = dir == EdgeDirection.Outgoing ?
                (x -> new Edge(e, x)) : (x -> new Edge(x, e));

        return threadEventsMap.entrySet().stream()
                .filter(x -> x.getKey() != e.getThread())
                .flatMap(x -> x.getValue().stream())
                .map(edgeMapping);
    }

    @Override
    public void constructFromModel(ExecutionModel context) {
        super.constructFromModel(context);
        threadEventsMap = context.getThreadEventsMap();
        int totalSize = context.getEventList().size();
        for (List<EventData> threadEvents : context.getThreadEventsMap().values()) {
            int threadSize = threadEvents.size();
            size += (totalSize - threadSize) * threadSize;
        }
    }

}
