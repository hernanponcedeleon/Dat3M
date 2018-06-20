package porthosc.languages.conversion.tozformula.process;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import porthosc.languages.common.graph.FlowGraph;
import porthosc.languages.conversion.tozformula.StaticSingleAssignmentMap;
import porthosc.languages.conversion.tozformula.XDataflowEncoder;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.process.XProcess;

import java.util.Iterator;
import java.util.Set;


public class XPreludeEncoder implements XFlowGraphEncoder {

    private final Context ctx;
    private final StaticSingleAssignmentMap ssaMap;
    private final XDataflowEncoder dataFlowEncoder;

    public XPreludeEncoder(Context ctx, StaticSingleAssignmentMap ssaMap, XDataflowEncoder dataFlowEncoder) {
        this.ctx = ctx;
        this.ssaMap = ssaMap;
        this.dataFlowEncoder = dataFlowEncoder;
    }

    @Override
    public BoolExpr encodeProcess(XProcess process) {
        BoolExpr enc = ctx.mkTrue();

        Iterator<XEvent> nodesIterator = process.linearisedNodesIterator();
        // execute the entry event indefinitely:
        enc = ctx.mkAnd(enc, process.source().executes(ctx));

        while (nodesIterator.hasNext()) {
            XEvent currentEvent = nodesIterator.next();
            BoolExpr currentVar = currentEvent.executes(ctx);

            // TODO: this is bad, that dataFlowEncoder implicitly depends on ssaMap: ssa-map update must be inside data-flow encoder!
            for (boolean edgeKind : FlowGraph.edgeKinds()) {
                if (!process.hasParent(edgeKind, currentEvent)) {
                    continue;
                }
                Set<XEvent> parents = process.parents(edgeKind, currentEvent);
                assert parents.size() > 0 : "disconnected graph";
                for (XEvent parent : parents) {
                    ssaMap.updateRefs(currentEvent, parent);
                }
            }

            // TODO: default init by 0 !

            // encode event's inner data-flow:
            BoolExpr currentEventDataFlowAssert = currentEvent.accept(dataFlowEncoder);
            if (currentEventDataFlowAssert != null) {
                enc = ctx.mkAnd(enc, ctx.mkImplies(currentVar, currentEventDataFlowAssert));
            }
        }
        return enc;
    }

    @Override
    public BoolExpr encodeProcessRFRelation(XProcess process) {
        //throw new NotImplementedException();
        return ctx.mkTrue();
    }
}
