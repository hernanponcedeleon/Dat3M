package porthosc.languages.common.graph.traverse;

import porthosc.languages.common.graph.FlowGraph;
import porthosc.languages.common.graph.FlowGraphNode;
import porthosc.languages.common.graph.UnrolledFlowGraphBuilder;


abstract class DfsTraverseActor<N extends FlowGraphNode, G extends FlowGraph<N>> {
    protected final UnrolledFlowGraphBuilder<N, G> builder;

    DfsTraverseActor(UnrolledFlowGraphBuilder<N, G> builder) {
        this.builder = builder;
    }

    public void onStart() {
        // do nothing yet
    }

    public void onNodePreVisit(N node) {
        // do nothing yet
    }

    public void onEdgeVisit(boolean edgeKind, N from, N to) {
        // do nothing yet
    }

    public void onNodePostVisit(N node) {
        // do nothing yet
    }

    public void onLastNodeVisit(N lastNode) {
        // do nothing yet
    }

    public void onFinish() {
        // do nothing yet
    }
}
