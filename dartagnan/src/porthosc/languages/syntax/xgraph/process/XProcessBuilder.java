package porthosc.languages.syntax.xgraph.process;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import porthosc.languages.common.graph.FlowGraphNode;
import porthosc.languages.common.graph.UnrolledFlowGraphBuilder;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.computation.XComputationEvent;
import porthosc.languages.syntax.xgraph.events.fake.XEntryEvent;
import porthosc.languages.syntax.xgraph.events.fake.XExitEvent;
import porthosc.languages.syntax.xgraph.memories.XLocalLvalueMemoryUnit;
import porthosc.utils.CollectionUtils;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;


public class XProcessBuilder extends UnrolledFlowGraphBuilder<XEvent, XProcess> {
    private final XProcessId processId;

    private Map<XEvent, Set<XLocalLvalueMemoryUnit>> condRegMap = new HashMap<>();

    public XProcessBuilder(XProcessId processId, int size) {
        super(size);
        this.processId = processId;
    }

    @Override
    public XProcess build() {
        finishBuilding();
        return new XProcess(getProcessId(),
                            getSource(),
                            getSink(),
                            buildEdges(true),
                            buildEdges(false),
                            buildReversedEdges(true),
                            buildReversedEdges(false),
                            buildNodesLinearised(),
                            buildCondLevelMap(),
                            buildCondRegMap());
    }

    private ImmutableMap<XEvent, ImmutableSet<XLocalLvalueMemoryUnit>> buildCondRegMap() {
        return CollectionUtils.buildMapOfSets(condRegMap);
    }

    @Override
    public void finishBuilding() {
        // todo: commented for debugging
        /*for (XEvent node : buildNodesLinearised()) {
            XLocalMemoryUnitCollector localMemoryUnitCollector = new XLocalMemoryUnitCollector();
            for (boolean b : FlowGraph.edgeKinds()) {
                Map<XEvent, Set<XEvent>> reversedEdges = getReversedEdges(b);
                if (!reversedEdges.containsKey(node)) {
                    continue;
                }
                for (XEvent parent : reversedEdges.get(node)) {
                    assert condRegMap.containsKey(parent) : parent + ", " + node;
                    assert parent.getRefId() <= node.getRefId() : parent.getRefId() + "," + node.getRefId(); //just a check

                    Set<XLocalLvalueMemoryUnit> nodeSet = condRegMap.getOrDefault(node, new HashSet<>());
                    nodeSet.addAll(condRegMap.get(parent));
                    XComputationEvent branching = asBranchingNodeOrNull(node);
                    if (branching != null) {
                        for (XLocalMemoryUnit localMemoryUnit : node.accept(localMemoryUnitCollector)) {
                            if (localMemoryUnit instanceof XLocalLvalueMemoryUnit) {
                                nodeSet.add((XLocalLvalueMemoryUnit) localMemoryUnit);
                            }
                        }
                    }
                    condRegMap.put(node, nodeSet);
                }
            }
        }*/

        super.finishBuilding();
    }

    @Override
    public XEvent createNodeRef(XEvent node, int newRefId) {
        assert node.getRefId() == FlowGraphNode.NOT_UNROLLED_REF_ID : "Attempt to create ref for node that is already a ref: " + node;
        return node.asNodeRef(newRefId);
    }

    @Override
    public XEntryEvent getSource() {
        return (XEntryEvent) super.getSource();
    }

    @Override
    public XExitEvent getSink() {
        return (XExitEvent) super.getSink();
    }

    public XProcessId getProcessId() {
        return processId;
    }

    @Override
    public void setSource(XEvent source) {
        if (!(source instanceof XEntryEvent)) {
            throw new IllegalArgumentException();
        }
        super.setSource(source);
        condRegMap.put(source, new HashSet<>());
    }

    @Override
    public void setSink(XEvent sink) {
        if (!(sink instanceof XExitEvent)) {
            throw new IllegalArgumentException();
        }
        super.setSink(sink);
    }

    public XComputationEvent asBranchingNodeOrNull(XEvent event) {
        if (altEdges.containsKey(event)) {
            if (!(event instanceof XComputationEvent)) {
                throw new IllegalArgumentException();
            }
            return (XComputationEvent) event;
        }
        return null;
    }
}
