package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class ProgramOrderGraph extends StaticWMMGraph {

    private Map<Thread, List<EventData>> threadEventsMap;

    @Override
    public int size(int id, EdgeDirection dir) {
        EventData e = getEvent(id);
        if (dir == EdgeDirection.OUTGOING) {
            return (threadEventsMap.get(e.getThread()).size() - e.getLocalId()) - 1;
        } else {
            return e.getLocalId() - 1;
        }
    }

    @Override
    public boolean containsById(int id1, int id2) {
        EventData a = getEvent(id1);
        EventData b = getEvent(id2);
        return a.getThread() == b.getThread() && b.getLocalId() > a.getLocalId();
    }

    @Override
    public void repopulate() {
        this.threadEventsMap = model.getThreadEventsMap();
        size = 0;
        for (List<EventData> threadEvents : threadEventsMap.values()) {
            size += ((threadEvents.size() - 1) * threadEvents.size()) >> 1;
        }
    }

    @Override
    public Stream<Edge> edgeStream() {
        return IntStream.range(0, domain.size())
                .mapToObj(i -> edgeStream(i, EdgeDirection.OUTGOING))
                .flatMap(s -> s);
    }

    @Override
    public Stream<Edge> edgeStream(int id, EdgeDirection dir) {
        EventData e = getEvent(id);
        List<EventData> threadEvents = model.getThreadEventsMap().get(e.getThread());
        if (dir == EdgeDirection.OUTGOING) {
            return threadEvents.subList(e.getLocalId() + 1, threadEvents.size())
                    .stream().map(x -> new Edge(id, x.getId()));
        } else {
            return threadEvents.subList(0, e.getLocalId())
                    .stream().map(x -> new Edge(x.getId(), id));
        }
    }
}
