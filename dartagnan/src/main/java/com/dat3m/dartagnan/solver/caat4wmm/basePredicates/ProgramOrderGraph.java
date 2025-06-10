package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.InstructionBoundary;
import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class ProgramOrderGraph extends StaticWMMGraph {

    private Map<Thread, List<EventData>> threadEventsMap;
    private Map<Integer, List<Integer>> transactions;

    @Override
    public int size(int id, EdgeDirection dir) {
        final EventData e = getEvent(id);
        final List<Integer> transaction = transactions.get(id);
        final int localId = e.getLocalId();
        final boolean outgoing = dir == EdgeDirection.OUTGOING;
        final int indexInTransaction = transaction == null ? 0 : transaction.indexOf(id);
        final int transactionSize = transaction == null ? 1 : transaction.size();
        final int sizeByTransaction = outgoing ? transactionSize - indexInTransaction : indexInTransaction + 1;
        final int sizeByThread = outgoing ? threadEventsMap.get(e.getThread()).size() - localId : localId;
        return sizeByThread - sizeByTransaction;
    }

    @Override
    public boolean containsById(int id1, int id2) {
        final EventData a = getEvent(id1);
        final EventData b = getEvent(id2);
        if (a.getThread() != b.getThread() || b.getLocalId() <= a.getLocalId()) {
            return false;
        }
        final List<Integer> transaction = transactions.get(id1);
        return transaction == null || transaction != transactions.get(id2);
    }

    @Override
    public void repopulate() {
        this.threadEventsMap = model.getThreadEventsMap();
        this.transactions = new HashMap<>();
        size = 0;
        for (List<EventData> threadEvents : threadEventsMap.values()) {
            size += ((threadEvents.size() - 1) * threadEvents.size()) >> 1;
        }
        for (InstructionBoundary end : model.getProgram().getThreadEvents(InstructionBoundary.class)) {
            final List<Event> events = end.getInstructionEvents();
            final List<Integer> transaction = new ArrayList<>();
            for (Event event : events) {
                final int id = model.getData(event).map(EventData::getId).orElse(-1);
                if (id >= 0) {
                    transaction.add(id);
                    transactions.put(id, transaction);
                }
            }
            size -= (transaction.size() * (transaction.size() - 1)) / 2;
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
        final EventData e = getEvent(id);
        final List<Integer> transaction = transactions.get(id);
        final List<EventData> threadEvents = threadEventsMap.get(e.getThread());
        if (dir == EdgeDirection.OUTGOING) {
            final int lastIndex = transaction == null ? -1 : transaction.get(transaction.size() - 1);
            final EventData last = transaction == null ? e : model.getEventList().get(lastIndex);
            return threadEvents.subList(last.getLocalId() + 1, threadEvents.size())
                    .stream().map(x -> new Edge(id, x.getId()));
        } else {
            final int firstIndex = transaction == null ? -1 : transaction.get(0);
            final EventData first = transaction == null ? e : model.getEventList().get(firstIndex);
            return threadEvents.subList(0, first.getLocalId())
                    .stream().map(x -> new Edge(x.getId(), id));
        }
    }
}
