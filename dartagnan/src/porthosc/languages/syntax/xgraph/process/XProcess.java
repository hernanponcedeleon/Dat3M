package porthosc.languages.syntax.xgraph.process;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import porthosc.languages.common.graph.UnrolledFlowGraph;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.fake.XEntryEvent;
import porthosc.languages.syntax.xgraph.events.fake.XExitEvent;
import porthosc.languages.syntax.xgraph.memories.XLocalLvalueMemoryUnit;


public final class XProcess extends UnrolledFlowGraph<XEvent> {

    private final XProcessId id;
    private final ImmutableMap<XEvent, ImmutableSet<XLocalLvalueMemoryUnit>> condRegMap;

    XProcess(XProcessId id,
             XEntryEvent source,
             XExitEvent sink,
             ImmutableMap<XEvent, XEvent> edges,
             ImmutableMap<XEvent, XEvent> altEdges,
             ImmutableMap<XEvent, ImmutableSet<XEvent>> edgesReversed,
             ImmutableMap<XEvent, ImmutableSet<XEvent>> altEdgesReversed,
             ImmutableList<XEvent> nodesLinearised,
             ImmutableMap<XEvent, Integer> condLevelMap,
             ImmutableMap<XEvent, ImmutableSet<XLocalLvalueMemoryUnit>> condRegMap) {
        super(source, sink, edges, altEdges, edgesReversed, altEdgesReversed, nodesLinearised, condLevelMap);
        this.id = id;
        this.condRegMap = condRegMap;
    }

    public XProcessId getId() {
        return id;
    }

    @Override
    public XEntryEvent source() {
        return (XEntryEvent) super.source();
    }

    @Override
    public XExitEvent sink() {
        return (XExitEvent) super.sink();
    }

    public ImmutableSet<XLocalLvalueMemoryUnit> getCondRegs(XEvent event) {
        return condRegMap.get(event);
    }
}
