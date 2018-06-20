package porthosc.languages.syntax.xgraph.process;

import com.google.common.collect.ImmutableMap;
import porthosc.languages.common.graph.FlowGraph;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.fake.XEntryEvent;
import porthosc.languages.syntax.xgraph.events.fake.XExitEvent;


public class XCyclicProcess extends FlowGraph<XEvent> {

    private final XProcessId id;

    XCyclicProcess(XProcessId id,
                   XEntryEvent source,
                   XExitEvent sink,
                   ImmutableMap<XEvent, XEvent> trueEdges,
                   ImmutableMap<XEvent, XEvent> falseEdges) {
        super(source, sink, trueEdges, falseEdges);
        this.id = id;
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
}
