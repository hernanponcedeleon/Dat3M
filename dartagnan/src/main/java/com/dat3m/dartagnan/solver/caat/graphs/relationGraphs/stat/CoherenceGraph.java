package com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.stat;

import com.dat3m.dartagnan.solver.caat.graphs.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.util.EdgeDirection;
import com.dat3m.dartagnan.solver.caat.util.GraphVisitor;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.google.common.collect.Iterators;

import java.math.BigInteger;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

import static java.util.Spliterator.*;

public class CoherenceGraph extends StaticRelationGraph {

    private Map<BigInteger, List<EventData>> coMap;

    @Override
    public Optional<Edge> get(Edge edge) {
        return contains(edge.getFirst(), edge.getSecond()) ? Optional.of(edge.with(0, 0)) : Optional.empty();
    }

    @Override
    public int getMinSize(EventData e, EdgeDirection dir) {
        if (!e.isWrite()) {
            return 0;
        }
        List<EventData> sameAddrWrites = coMap.get(e.getAccessedAddress());
        if (sameAddrWrites == null) {
            return 0;
        }
        int index = e.getCoherenceIndex();
        return dir == EdgeDirection.INGOING ? (index - 1) : (sameAddrWrites.size() - index - 1);
    }

    @Override
    public boolean contains(EventData a, EventData b) {
        return a.getCoherenceIndex() < b.getCoherenceIndex() && a.isWrite() && b.isWrite()
                && a.getAccessedAddress().equals(b.getAccessedAddress());
    }

    @Override
    public void constructFromModel(ExecutionModel model) {
        super.constructFromModel(model);
        coMap = new HashMap<>(model.getCoherenceMap());
        coMap.values().removeIf(list -> list.size() <= 1);
        autoComputeSize();
    }

    @Override
    public <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context) {
        return visitor.visitBase(this, data, context);
    }

    @Override
    public Stream<Edge> edgeStream() {
        return StreamSupport.stream(
                Spliterators.spliterator(edgeIterator(), size, SIZED | NONNULL | DISTINCT | IMMUTABLE | ORDERED),
                false
        );
    }

    @Override
    public Stream<Edge> edgeStream(EventData e, EdgeDirection dir) {
        if (!e.isWrite()) {
            return Stream.empty();
        }
        Function<EventData, Edge> mapping = dir == EdgeDirection.INGOING ?
                (event -> new Edge(event, e)) : (event -> new Edge(e, event));
        return getCoSuccessorList(e, dir).stream().map(mapping);
    }

    @Override
    public Iterator<Edge> edgeIterator() {
        return new CoIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        if (!e.isWrite()) {
            return Collections.emptyIterator();
        }
        com.google.common.base.Function<EventData, Edge> mapping = dir == EdgeDirection.INGOING ?
                (event -> new Edge(event, e)) : (event -> new Edge(e, event));
        return Iterators.transform(getCoSuccessorList(e, dir).iterator(), mapping);
    }

    private List<EventData> getCoSuccessorList(EventData e, EdgeDirection dir) {
        List<EventData> sameAddrWrites = coMap.get(e.getAccessedAddress());
        if (sameAddrWrites == null) {
            return Collections.emptyList();
        }
        int index = e.getCoherenceIndex();
        return (dir == EdgeDirection.INGOING ?
                sameAddrWrites.subList(0, index)
                : sameAddrWrites.subList(index + 1, sameAddrWrites.size()));
    }

    private class CoIterator implements Iterator<Edge> {

        private final Iterator<List<EventData>> coListIterator = coMap.values().iterator();
        private List<EventData> curList = Collections.emptyList();
        private int low = 0, high = 0;
        private Edge edge;

        public CoIterator() {
            findNext();
        }

        private void findNext() {
            if (++high >= curList.size()) {
                if (++low < curList.size() - 1) {
                    high = low + 1;
                } else {
                    if (coListIterator.hasNext()) {
                        curList = coListIterator.next();
                        low = 0;
                        high = 1;
                    } else {
                        edge = null;
                        return;
                    }
                }
            }
            edge = new Edge(curList.get(low), curList.get(high));

        }

        @Override
        public boolean hasNext() {
            return edge != null;
        }

        @Override
        public Edge next() {
            Edge e = edge;
            findNext();
            return e;
        }

    }
}
