package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.stat;

import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.CoreLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.coreReason.RfLiteral;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.EdgeIterator;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.IteratorUtils;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.analysis.graphRefinement.logic.Conjunction;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;

import java.util.Iterator;
import java.util.Map;

public class ReadFromGraph extends StaticEventGraph {

    @Override
    public boolean contains(Edge edge) {
        return edge.getSecond().getReadFrom() == edge.getFirst();
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

    @Override
    public Iterator<Edge> edgeIterator() {
        return new RfIterator();
    }

    @Override
    public Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        if (e.isWrite()) {
            return dir == EdgeDirection.Outgoing ? new RfIterator(e, dir) : IteratorUtils.empty();
        } else if (e.isRead()) {
            return dir == EdgeDirection.Ingoing ?
                    IteratorUtils.singleton(new Edge(e.getReadFrom(), e)) : IteratorUtils.empty();
        }
        return IteratorUtils.empty();
    }

    @Override
    public Conjunction<CoreLiteral> computeReason(Edge edge) {
        return contains(edge) ? new Conjunction<>(new RfLiteral(edge)) : Conjunction.FALSE;
    }

    private class RfIterator extends EdgeIterator {

        private Iterator<EventData> readIterator;
        private Iterator<Map.Entry<EventData, EventData>> readWriteIterator;

        public RfIterator() {
            super(true);
            readWriteIterator = context.getReadWriteMap().entrySet().iterator();
            nextSecond();
        }


        public RfIterator(EventData fixed, EdgeDirection dir) {
            super(fixed, dir);
            // We assume that the fixed event is a write and we look for outgoing edges.
            // In all other cases, the iterator would only produce one or no element.
            // And we expect them to be covered explicitly
            if (!firstIsFixed && !fixed.isWrite())
                throw new IllegalArgumentException("Iteration from " + fixed + " is not supported");
            readIterator = context.getWriteReadsMap().get(first).iterator();
            nextSecond();
        }

        // The following 3 methods should never get called
        @Override
        protected void resetFirst() {
            first = null;
            //throw new UnsupportedOperationException("This should never happen");
        }

        @Override
        protected void resetSecond() {
            second = null;
            //throw new UnsupportedOperationException("This should never happen");
        }

        @Override
        protected void nextFirst() {
            first = null;
            //throw new UnsupportedOperationException("This should never happen");
        }

        @Override
        protected void nextSecond() {
            if (readIterator != null) {
                // If a write is fixed, iterate over all reading reads
                second = readIterator.hasNext() ? readIterator.next() : null;
            } else {
                // If no write is fixed, instead iterate to the next read and its sole write
                if (readWriteIterator.hasNext()) {
                    Map.Entry<EventData, EventData> entry = readWriteIterator.next();
                    first = entry.getValue();
                    second = entry.getKey();
                } else {
                    first = second = null;
                }
            }
        }
    }
}
