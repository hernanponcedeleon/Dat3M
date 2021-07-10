package com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph;

import com.dat3m.dartagnan.analysis.graphRefinement.graphs.GraphDerivable;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.iteration.OneTimeIterable;
import com.dat3m.dartagnan.analysis.graphRefinement.graphs.eventGraph.utils.GraphSetView;
import com.dat3m.dartagnan.analysis.graphRefinement.util.EdgeDirection;
import com.dat3m.dartagnan.analysis.graphRefinement.util.GraphVisitor;
import com.dat3m.dartagnan.utils.timeable.Timestamp;
import com.dat3m.dartagnan.verification.model.Edge;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

public interface EventGraph extends GraphDerivable, Iterable<Edge> {

    @Override
    List<? extends EventGraph> getDependencies();

    void setName(String name);
    String getName();

    // Returns the edge that is stored in this graph, including all the metadata
    // Returns NULL, if the edge is not present
    Edge get(Edge edge);

    //TODO: We might want to make these default
    boolean contains(EventData a, EventData b);
    Timestamp getTime(EventData a, EventData b);

    void constructFromModel(ExecutionModel model);
    ExecutionModel getModel();

    <TRet, TData, TContext> TRet accept(GraphVisitor<TRet, TData, TContext> visitor, TData data, TContext context);

    int size();

    int getMinSize();
    int getMinSize(EventData e, EdgeDirection dir);
    int getMaxSize();
    int getMaxSize(EventData e, EdgeDirection dir);

    Stream<Edge> edgeStream();
    Stream<Edge> edgeStream(EventData e, EdgeDirection dir);

    // ================= Default methods ==================

    default Set<Edge> setView() { return new GraphSetView(this); }

    default boolean contains(Edge edge) { return contains(edge.getFirst(), edge.getSecond()); }
    default Timestamp getTime(Edge edge) { return getTime(edge.getFirst(), edge.getSecond()); }

    default  boolean isEmpty() { return size() == 0; }

    default boolean containsAll(Collection<? extends Edge> edges) {
        return edges.stream().allMatch(this::contains);
    }

    default int getEstimatedSize() { return (getMinSize() + getMaxSize()) >> 1; }
    default int getEstimatedSize(EventData e, EdgeDirection dir) {
        return (getMinSize(e, dir) + getMaxSize(e, dir)) >> 1;
    }

    default Stream<Edge> outEdgeStream(EventData e) {
        return edgeStream(e, EdgeDirection.Outgoing);
    }
    default Stream<Edge> inEdgeStream(EventData e) {
        return edgeStream(e, EdgeDirection.Ingoing);
    }

    default Iterator<Edge> edgeIterator() {
        return edgeStream().iterator();
    }
    default Iterator<Edge> edgeIterator(EventData e, EdgeDirection dir) {
        return edgeStream(e, dir).iterator();
    }

    default Iterable<Edge> edges() { return OneTimeIterable.create(edgeIterator()); }
    default Iterable<Edge> edges(EventData e, EdgeDirection dir)
    { return OneTimeIterable.create(edgeIterator(e, dir)); }

    default Iterator<Edge> inEdgeIterator(EventData e) { return edgeIterator(e, EdgeDirection.Ingoing); }
    default Iterator<Edge> outEdgeIterator(EventData e) { return edgeIterator(e, EdgeDirection.Outgoing); }

    default Iterable<Edge> inEdges(EventData e) { return OneTimeIterable.create(inEdgeIterator(e)); }
    default Iterable<Edge> outEdges(EventData e) {  return OneTimeIterable.create(outEdgeIterator(e)); }

}
