package porthosc.languages.common.graph.traverse;

import porthosc.languages.common.graph.FlowGraphNode;
import porthosc.languages.common.graph.UnrolledFlowGraph;
import porthosc.languages.common.graph.UnrolledFlowGraphBuilder;


class DfsLinearisationActor<N extends FlowGraphNode, G extends UnrolledFlowGraph<N>>
        extends DfsTraverseActor<N, G> {

    DfsLinearisationActor(UnrolledFlowGraphBuilder<N, G> builder) {
        super(builder);
    }

    @Override
    public void onNodePostVisit(N node) {
        builder.processTopologicallyNextNode(node);
    }
}
