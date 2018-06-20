package porthosc.languages.common.graph;

import com.google.common.collect.ImmutableList;


public abstract class FlowTree<
        N extends FlowGraphNode,
        G extends FlowGraph<N>> {

    private final ImmutableList<G> graphs;

    public FlowTree(ImmutableList<G> graphs) {
        this.graphs = graphs;
    }

    protected ImmutableList<G> getGraphs() {
        return graphs;
    }
}
