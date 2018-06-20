package porthosc.languages.common.graph.traverse;

import com.google.common.collect.ImmutableSet;
import porthosc.languages.common.graph.FlowGraphNode;
import porthosc.languages.common.graph.UnrolledFlowGraph;
import porthosc.languages.common.graph.UnrolledFlowGraphBuilder;


class CompositeDfsTraverseActor<N extends FlowGraphNode, G extends UnrolledFlowGraph<N>>
        extends DfsTraverseActor<N, G> {

    private final ImmutableSet<DfsTraverseActor<N, G>> actors;

    CompositeDfsTraverseActor(UnrolledFlowGraphBuilder<N, G> builder) {
        super(builder);
        // Add here new actors that gather information about graph during graph traverse
        ImmutableSet.Builder<DfsTraverseActor<N, G>> actorsBuilder = new ImmutableSet.Builder<>();
        actorsBuilder.add(new DfsUnrollingActor<>(builder));
        actorsBuilder.add(new DfsLinearisationActor<>(builder));
        this.actors = actorsBuilder.build();
    }

    public G buildGraph() {
        return builder.build();
    }

    @Override
    public void onStart() {
        for (DfsTraverseActor<N, G> actor : actors) {
            actor.onStart();
        }
    }

    @Override
    public void onNodePreVisit(N node) {
        for (DfsTraverseActor<N, G> actor : actors) {
            actor.onNodePreVisit(node);
        }
    }

    @Override
    public void onEdgeVisit(boolean edgeKind, N from, N to) {
        for (DfsTraverseActor<N, G> actor : actors) {
            actor.onEdgeVisit(edgeKind, from, to);
        }
    }

    @Override
    public void onNodePostVisit(N node) {
        for (DfsTraverseActor<N, G> actor : actors) {
            actor.onNodePostVisit(node);
        }
    }

    @Override
    public void onLastNodeVisit(N lastNode) {
        for (DfsTraverseActor<N, G> actor : actors) {
            actor.onLastNodeVisit(lastNode);
        }
    }

    @Override
    public void onFinish() {
        for (DfsTraverseActor<N, G> actor : actors) {
            actor.onFinish();
        }
    }
}
