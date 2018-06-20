package porthosc.languages.common.graph;

import com.google.common.collect.ImmutableMap;
import porthosc.utils.patterns.BuilderBase;

import javax.annotation.Nullable;
import java.util.HashMap;
import java.util.Map;

import static porthosc.utils.StringUtils.wrap;


public abstract class FlowGraphBuilder<N extends FlowGraphNode, G extends FlowGraph<N>>
        extends BuilderBase<G>
        implements IFlowGraphBuilder<N, G> {

    protected final Map<N, N> edges;
    protected final Map<N, N> altEdges;
    private N source;
    private N sink;

    public FlowGraphBuilder() {
        this.edges = new HashMap<>();
        this.altEdges = new HashMap<>();
    }

    @Override
    public N getSource() {
        return source;
    }

    @Override
    public N getSink() {
        return sink;
    }

    @Override
    public ImmutableMap<N, N> buildEdges(boolean edgeSign) {
        return ImmutableMap.copyOf(getEdges(edgeSign));
    }

    // --

    @Override
    public void finishBuilding() {
        // TODO: maybe add some more checks here
        assert getSource() != null : "source node is not set";
        assert getSink() != null : "sink node is not set";
        markFinished();
    }

    @Override
    public void setSource(N source) {
        assert this.source == null : "source node has already been set";
        this.source = source;
    }

    @Override
    public void setSink(N sink) {
        assert this.sink == null : "sink node has already been set";
        this.sink = sink;
    }

    @Override
    public void addEdge(boolean edgeSign, N from, N to) {
        if (!edgeSign && hasEdge(true, from, to)) {
            return; // do not add 'false' edge that duplicates the 'true' edge
        }
        addEdgeImpl(edgeSign, from, to);
    }

    @Override
    public boolean hasEdgesFrom(N node) {
        return getEdges(true).containsKey(node) || getEdges(false).containsKey(node);
    }

    @Override
    public boolean hasEdge(boolean edgeSign, N from, N to) {
        Map<N, N> map = getEdges(edgeSign);
        return map.containsKey(from) && map.get(from).equals(to);
    }

    public boolean isBranchingNode(N node) {
        return altEdges.containsKey(node);
    }

    protected Map<N, N> getEdges(boolean edgeSign) {
        return edgeSign ? edges : altEdges;
    }

    private void addEdgeImpl(boolean edgeSign, @Nullable N from, N to) {
        assert (to != null) : "attempt to add to graph the null node";

        Map<N, N> edgesMap = getEdges(edgeSign);
        Map<N, N> altEdgesMap = getEdges(!edgeSign);

        // TODO: this check is for debug only
        // TODO: remove this after tests are completed
        if (edgesMap.containsKey(from)) {
            N oldTo = edgesMap.get(from);
            if (!oldTo.equals(to)) {
                System.err.println("WARNING: overwriting " + (edgeSign?"primary":"alternative") + "-edge " + wrap(from + " -> " + oldTo)
                                           + " with edge " + wrap(from + " -> " + to));
                edgesMap.remove(from, oldTo);
            }
        }

        if (altEdgesMap.containsKey(from) && altEdgesMap.get(from).equals(to)) {
            throw new IllegalArgumentException("Attempt to add " + getEdgeTypeText(edgeSign) + "-edge while already having " +
                    getEdgeTypeText(!edgeSign) + "-edge " + from + " -> " + to);
        }

        edgesMap.put(from, to);
    }

    private String getEdgeTypeText(boolean edgeSign) {
        return (edgeSign) ? "true" : "false";
    }
}