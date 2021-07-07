package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

public class ProgramOrderGraph extends StaticEventGraph {

    private Map<Thread, List<EventData>> threadEventsMap;

    @Override
    public boolean contains(Edge edge) {
        return edge.isForwardEdge();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        if (dir == EdgeDirection.Outgoing) {
            return (threadEventsMap.get(e.getThread()).size() - e.getLocalId()) - 1;
        } else {
            return e.getLocalId() - 1;
        }
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return a.getThread() == b.getThread() && b.getLocalId() > a.getLocalId();
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        this.threadEventsMap = model.getThreadEventsMap();
        size = 0;
        for (List<EventData> threadEvents : threadEventsMap.values()) {
            size += ((threadEvents.size() - 1) * threadEvents.size()) >> 1;
        }
    }

    @Override
    public Stream<Edge> edgeStream() {
        return model.getEventList().stream().flatMap(x -> edgeStream(x, EdgeDirection.Outgoing));
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        List<EventData> threadEvents = model.getThreadEventsMap().get(e.getThread());
        if (dir == EdgeDirection.Outgoing) {
            return threadEvents.subList(e.getLocalId() + 1, threadEvents.size()).stream().map(x -> new Edge(e, x));
        } else {
            return threadEvents.subList(0, e.getLocalId()).stream().map(x -> new Edge(x, e));
        }
    }
}
