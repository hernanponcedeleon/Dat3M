package porthosc.languages.common.graph;

import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Predicate;


public class FlowGraph<N extends FlowGraphNode> {

    private final N source;
    private final N sink;
    private final ImmutableMap<N, N> edges;
    private final ImmutableMap<N, N> altEdges;

    private final Map<Predicate<N>, ImmutableSet<N>> nodeQueriesCache;

    public FlowGraph(N source,
                     N sink,
                     ImmutableMap<N, N> edges,
                     ImmutableMap<N, N> altEdges) {
        this.source = source;
        this.sink = sink;
        this.edges = edges;
        this.altEdges = altEdges;
        this.nodeQueriesCache = new HashMap<>();
    }

    public static boolean[] edgeKinds() {
        return new boolean[]{ true, false };
    }

    public N source() {
        return source;
    }

    public N sink() {
        return sink;
    }

    public boolean isSource(N node) {
        return node == source;
    }

    public boolean isSink(N node) {
        return node == sink;
    }

    public N child(boolean edgeSign, N node) {
        return getEdges(edgeSign).get(node);
    }

    public boolean hasChild(boolean edgeSign, N node) {
        return getEdges(edgeSign).containsKey(node);
    }

    public boolean isBranchingNode(N node) {
        return hasChild(false, node);
    }

    // TODO: after debugging, probably remove these methods?
    // ================================================ optional methods (to be removed) ===============================

    public ImmutableMap<N, N> getEdges(boolean edgesSign) {
        return edgesSign ? edges : altEdges;
    }


    public int size() {
        // todo: count nodes while single-pass via information collector!
        return edges.values().size();
    }

    public ImmutableCollection<N> getAllNodesExceptSource() {
        return getEdges(true).values();
    }

    // TODO: this should be only per program (?)
    public ImmutableSet<N> getNodesExceptSource(Predicate<N> filter) {
        if (nodeQueriesCache.containsKey(filter)) {
            return nodeQueriesCache.get(filter);
        }
        ImmutableSet.Builder<N> builder = new ImmutableSet.Builder<>();
        for (N node : getAllNodesExceptSource()) {
            if (filter.test(node)) {
                builder.add(node);
            }
        }
        ImmutableSet<N> result = builder.build();
        nodeQueriesCache.put(filter, result);
        return result;
    }

    // =====================


    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("FlowGraph{");
        sb.append("source=").append(source);
        sb.append(", sink=").append(sink);
        sb.append(", edges=").append(edges);
        sb.append(", altEdges=").append(altEdges);
        sb.append('}');
        return sb.toString();
    }
}
