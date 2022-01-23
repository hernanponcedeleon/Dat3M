package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class ExternalGraph extends StaticWMMGraph {
    private Map<Thread, List<EventData>> threadEventsMap;

    @Override
    public boolean containsById(int id1, int id2) {
        EventData a = getEvent(id1);
        EventData b = getEvent(id2);
        return a.getThread() != b.getThread();
    }

    @Override
    public int size(int id, EdgeDirection dir) {
        return model.getEventList().size() - threadEventsMap.get(getEvent(id).getThread()).size();
    }

    @Override
    public Stream<Edge> edgeStream() {
        return IntStream.range(0, domain.size())
                .mapToObj(e -> edgeStream(e, EdgeDirection.OUTGOING))
                .flatMap(s -> s);
    }

    @Override
    public Stream<Edge> edgeStream(int id, EdgeDirection dir) {
        EventData e = getEvent(id);
        Function<EventData, Edge> edgeMapping = dir == EdgeDirection.OUTGOING ?
                (x -> new Edge(id, x.getId())) : (x -> new Edge(x.getId(), id));

        return threadEventsMap.entrySet().stream()
                .filter(x -> x.getKey() != e.getThread())
                .flatMap(x -> x.getValue().stream())
                .map(edgeMapping);
    }

    @Override
    public void repopulate() {
        threadEventsMap = model.getThreadEventsMap();
        int totalSize = model.getEventList().size();
        for (List<EventData> threadEvents : threadEventsMap.values()) {
            int threadSize = threadEvents.size();
            size += (totalSize - threadSize) * threadSize;
        }
    }

}
