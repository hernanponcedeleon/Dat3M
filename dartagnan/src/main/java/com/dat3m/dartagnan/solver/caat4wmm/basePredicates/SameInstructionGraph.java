package com.dat3m.dartagnan.solver.caat4wmm.basePredicates;

import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.InstructionBoundary;
import com.dat3m.dartagnan.solver.caat.misc.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.verification.model.EventData;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class SameInstructionGraph extends StaticWMMGraph {

    private Map<Integer, List<Integer>> transactions;

    @Override
    public int size(int id, EdgeDirection dir) {
        final List<Integer> transaction = transactions.get(id);
        return transaction == null ? 1 : transaction.size();
    }

    @Override
    public boolean containsById(int id1, int id2) {
        if (id1 == id2) {
            return true;
        }
        EventData a = getEvent(id1);
        EventData b = getEvent(id2);
        if (a.getThread() != b.getThread()) {
            return false;
        }
        final List<Integer> transaction = transactions.get(id1);
        return transaction != null && transaction == transactions.get(id2);
    }

    @Override
    public void repopulate() {
        this.transactions = new HashMap<>();
        size = model.getEventList().size();
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
            size += transaction.size() * (transaction.size() - 1);
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
        final List<Integer> transaction = transactions.get(id);
        final boolean outgoing = dir == EdgeDirection.OUTGOING;
        final Function<Integer, Edge> toEdge = outgoing ? (j -> new Edge(id, j)) : (j -> new Edge(j, id));
        return transaction == null ? Stream.of(new Edge(id, id)) : transaction.stream().map(toEdge);
    }
}
