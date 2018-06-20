package porthosc.languages.conversion.toxgraph.unrolling;

import porthosc.languages.common.graph.traverse.FlowGraphDfsTraverser;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.process.XCyclicProcess;
import porthosc.languages.syntax.xgraph.process.XProcess;
import porthosc.languages.syntax.xgraph.process.XProcessBuilder;


class XFlowGraphUnroller extends FlowGraphDfsTraverser<XEvent, XProcess> {

    // TODO: pass settings structure: bound, flags which agents to use

    XFlowGraphUnroller(XCyclicProcess graph, int unrollingBound) {
        super(graph, new XProcessBuilder(graph.getId(), graph.size()), unrollingBound);
    }
}
