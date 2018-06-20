package porthosc.languages.common.graph.traverse;

import porthosc.languages.common.graph.FlowGraph;
import porthosc.languages.common.graph.FlowGraphNode;
import porthosc.languages.common.graph.UnrolledFlowGraph;
import porthosc.languages.common.graph.UnrolledFlowGraphBuilder;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.Stack;


public abstract class FlowGraphDfsTraverser<N extends FlowGraphNode, G extends UnrolledFlowGraph<N>> {

    private final int unrollingBound;
    private final FlowGraph<N> graph;

    private final CompositeDfsTraverseActor<N, G> compositeActor;

    private Set<N> visitedRefs;
    private Stack<N> depthStack;
    private HashMap<N, Set<N>> backEdges;

    protected FlowGraphDfsTraverser(FlowGraph<N> graph,
                                    UnrolledFlowGraphBuilder<N, G> builder,
                                    int unrollingBound) {
        this.graph = graph;
        this.unrollingBound = unrollingBound;
        this.compositeActor = new CompositeDfsTraverseActor<>(builder);
        this.visitedRefs = new HashSet<>();
        this.depthStack = new Stack<>();
        this.backEdges = new HashMap<>();
    }

    public G getUnrolledGraph() {
        return compositeActor.buildGraph();
    }

    public void doUnroll() {
        compositeActor.onStart();
        N source = graph.source();
        N sourceRef = graph.source();
        unrollRecursively(source, sourceRef, 0, true);
        compositeActor.onFinish();
    }

    private void unrollRecursively(N node, N nodeRef, int depth, boolean needToUnrollChildren) {
        compositeActor.onNodePreVisit(nodeRef);

        if (visitedRefs.add(nodeRef)) {
            depthStack.push(node);

            if (needToUnrollChildren) {
                unrollChildRecursively(true, node, nodeRef, depth + 1);
                unrollChildRecursively(false, node, nodeRef, depth + 1);
            }
            else {
                compositeActor.onLastNodeVisit(node);
            }

            N popped = depthStack.pop();
            assert popped == node : popped + " must be " + node;
        }

        compositeActor.onNodePostVisit(nodeRef);
    }

    private void unrollChildRecursively(boolean edgeSign, N parent, N parentRef, int childDepth) {
        if (!graph.hasChild(edgeSign, parent)) { return; }

        N child = graph.child(edgeSign, parent);

        boolean isBackEdge = isMemoisedBackEdge(parent, child);
        if (!isBackEdge && depthStack.contains(child)) {
            memoiseBackEdge(parent, child);
            isBackEdge = true;
        }

        boolean isSink = (child == graph.sink());
        boolean boundAchieved = (childDepth > unrollingBound);
        boolean needToUnrollGrandChildren = !(isSink || boundAchieved);

        N childRef;
        if (needToUnrollGrandChildren) {
            childRef = compositeActor.builder.createNodeRef(child, childDepth);
        }
        else {
            childRef = getSinkNodeRef(isSink || isBackEdge);
            child = getSinkNode(isSink || isBackEdge);
        }

        compositeActor.onEdgeVisit(edgeSign, parentRef, childRef);
        unrollRecursively(child, childRef, childDepth, needToUnrollGrandChildren);
    }

    private N getSinkNode(boolean completed) {
        return completed
                ? graph.sink()
                : graph.sink(); // TODO: create incompleted sink node here
    }

    private N getSinkNodeRef(boolean completed) {
        return completed
                ? graph.sink()
                : graph.sink(); // TODO: create incompleted sink node here
    }

    private boolean isMemoisedBackEdge(N from, N to) {
        return backEdges.containsKey(from) && backEdges.get(from).contains(to);
    }

    private void memoiseBackEdge(N from, N to) {
        if (!backEdges.containsKey(from)) {
            backEdges.put(from, new HashSet<>());
        }
        backEdges.get(from).add(to);
    }
}
