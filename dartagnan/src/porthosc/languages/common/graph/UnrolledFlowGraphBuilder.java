package porthosc.languages.common.graph;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import porthosc.utils.CollectionUtils;

import java.util.*;


public abstract class UnrolledFlowGraphBuilder<N extends FlowGraphNode, G extends FlowGraph<N>>
        extends FlowGraphBuilder<N, G> {

    private Map<N, Set<N>> reversedEdges;
    private Map<N, Set<N>> altReversedEdges;

    // TODO: need new builder to test unrolled graph
    private Deque<N> linearisationQueue;
    private Map<N, Integer> condLevelMap;

    public UnrolledFlowGraphBuilder(int graphSize) {
        this.linearisationQueue = new LinkedList<>();
        this.reversedEdges = new HashMap<>(graphSize);
        this.altReversedEdges = new HashMap<>(graphSize);
        this.condLevelMap = new HashMap<>(graphSize);
    }

    public UnrolledFlowGraphBuilder() {
        this.linearisationQueue = new LinkedList<>();
        this.reversedEdges = new HashMap<>();
        this.altReversedEdges = new HashMap<>();
        this.condLevelMap = new HashMap<>();
    }

    public abstract N createNodeRef(N node, int newRefId);

    public ImmutableMap<N, ImmutableSet<N>> buildReversedEdges(boolean edgeSign) {
        return CollectionUtils.buildMapOfSets(getReversedEdges(edgeSign));
    }

    public void processTopologicallyNextNode(N node) {
        if (!linearisationQueue.contains(node)) { //contains: for exit-events only. TODO: check this constraint <--
            linearisationQueue.addFirst(node);
        }
    }

    @Override
    public void finishBuilding() {
        for (N node : linearisationQueue) {
            int maxParentLevel = 0;
            N maxParent = null;
            for (boolean b : FlowGraph.edgeKinds()) {
                Map<N, Set<N>> reversedEdges = getReversedEdges(b);
                if (reversedEdges.containsKey(node)) {
                    for (N parent : reversedEdges.get(node)) {
                        assert condLevelMap.containsKey(parent) : parent;
                        assert parent.getRefId() <= node.getRefId() : parent.getRefId() + "," + node.getRefId(); //just a check

                        int parentLevel = condLevelMap.get(parent);
                        if (parentLevel > maxParentLevel) {
                            maxParentLevel = parentLevel;
                            maxParent = parent;
                        }
                    }
                }
            }
            int nodeCondLevel = maxParentLevel;
            if (maxParent != null && isBranchingNode(maxParent)) {
                nodeCondLevel++;
            }
            assert nodeCondLevel >= 0 : node;
            condLevelMap.put(node, nodeCondLevel);
        }

        super.finishBuilding();
    }

    public ImmutableList<N> buildNodesLinearised() {
        return ImmutableList.copyOf(linearisationQueue);
        // todo: alternative way is to use level-ids (ref-id) :
        //List<N> result = new ArrayList<>(getEdges(true).size() + 1);
        //result.add(getSource());
        //
        //int currentLevel = 1;
        //while (true) {
        //    boolean added = false;
        //    for (boolean b : FlowGraph.edgeKinds()) {
        //        for (N node : getEdges(b).values()) {
        //            if (result.contains(node)) { continue; }
        //
        //            if (node.getRefId() == currentLevel) {
        //                result.add(node);
        //                added = true;
        //            }
        //        }
        //    }
        //    if (!added) {
        //        break;
        //    }
        //    currentLevel++;
        //}
        //return ImmutableList.copyOf(result);
    }

    public ImmutableMap<N, Integer> buildCondLevelMap() {
        return ImmutableMap.copyOf(condLevelMap);
    }

    @Override
    public void setSource(N source) {
        super.setSource(source);
        condLevelMap.put(source, 0);
    }

    @Override
    public void addEdge(boolean edgeSign, N from, N to) {
        super.addEdge(edgeSign, from, to);
        this.addReversedEdgeImpl(edgeSign, to, from);
    }

    protected Map<N, Set<N>> getReversedEdges(boolean edgeSign) {
        return edgeSign ? reversedEdges : altReversedEdges;
    }

    private void addReversedEdgeImpl(boolean edgeSign, N child, N parent) {
        Map<N, Set<N>> reversedEdgesMap = getReversedEdges(edgeSign);
        if (!reversedEdgesMap.containsKey(child)) {
            reversedEdgesMap.put(child, new HashSet<>());
        }
        reversedEdgesMap.get(child).add(parent);
    }
}