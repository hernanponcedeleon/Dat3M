package porthosc.languages.conversion.tozformula.process;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import porthosc.languages.common.graph.FlowGraph;
import porthosc.languages.conversion.tozformula.StaticSingleAssignmentMap;
import porthosc.languages.conversion.tozformula.XDataflowEncoder;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.computation.XComputationEvent;
import porthosc.languages.syntax.xgraph.events.memory.XLoadMemoryEvent;
import porthosc.languages.syntax.xgraph.events.memory.XStoreMemoryEvent;
import porthosc.languages.syntax.xgraph.memories.XSharedLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.process.XProcess;
import porthosc.utils.Utils;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;


public class XProcessEncoder implements XFlowGraphEncoder {

    private final Context ctx;
    private final StaticSingleAssignmentMap ssaMap;
    private final XDataflowEncoder dataFlowEncoder;

    public XProcessEncoder(Context ctx, StaticSingleAssignmentMap ssaMap, XDataflowEncoder dataFlowEncoder) {
        this.ctx = ctx;
        this.ssaMap = ssaMap;
        this.dataFlowEncoder = dataFlowEncoder;
    }

    // encodeCF + encodeDF
    @Override
    public BoolExpr encodeProcess(XProcess process) {
        BoolExpr enc = ctx.mkTrue();

        Iterator<XEvent> nodesIterator = process.linearisedNodesIterator();
        // execute the entry event indefinitely:
        enc = ctx.mkAnd(enc, process.source().executes(ctx));

        while (nodesIterator.hasNext()) {
            XEvent currentEvent = nodesIterator.next();
            BoolExpr currentVar = currentEvent.executes(ctx);

            // update SSA map + 'child -> (parent1 \/ parent2 \/ ...)'
            for (boolean edgeKind : FlowGraph.edgeKinds()) {
                if (!process.hasParent(edgeKind, currentEvent)) {
                    continue;
                }
                Set<XEvent> parents = process.parents(edgeKind, currentEvent);
                Set<BoolExpr> parentsVarsSet = new HashSet<>(parents.size());
                assert parents.size() > 0 : "disconnected graph";
                for (XEvent parent : parents) {
                    parentsVarsSet.add(parent.executes(ctx));
                    ssaMap.updateRefs(currentEvent, parent);
                }
                BoolExpr[] parentsVars = parentsVarsSet.toArray(new BoolExpr[0]);
                BoolExpr eitherParentAssert = (parentsVars.length == 1)
                        ? parentsVars[0]
                        : ctx.mkOr(parentsVars);
                enc = ctx.mkAnd(enc, ctx.mkImplies(currentVar, eitherParentAssert));
            }

            // if not a sink node:
            if (process.hasChild(true, currentEvent)) {
                // sequential: "X ; Y"
                // X=currentEvent, Y=child
                XEvent child = process.child(true, currentEvent);
                BoolExpr childVar = child.executes(ctx);

                if (process.hasChild(false, currentEvent)) {
                    // branching: "if (b) { X } else { Y }"
                    // b=currentEvent, X=child, Y=alternativeChild
                    XEvent alternativeChild = process.child(false, currentEvent);
                    BoolExpr alternativeChildVar = alternativeChild.executes(ctx);

                    // not together children:
                    BoolExpr notBothChildrenAssert = ctx.mkNot(ctx.mkAnd(childVar, alternativeChildVar));
                    enc = ctx.mkAnd(enc, notBothChildrenAssert);

                    // encode guard:
                    assert currentEvent instanceof XComputationEvent : "only XComputationEvent can be a branching point";
                    BoolExpr guard = dataFlowEncoder.encodeGuard((XComputationEvent) currentEvent);
                    // (child /\ parent) -> guard
                    BoolExpr thenBranchGuardAssert = ctx.mkImplies(ctx.mkAnd(childVar, currentVar), guard);
                    BoolExpr elseBranchGuardAssert = ctx.mkImplies(ctx.mkAnd(alternativeChildVar, currentVar), ctx.mkNot(guard));
                    enc = ctx.mkAnd(enc, thenBranchGuardAssert);
                    enc = ctx.mkAnd(enc, elseBranchGuardAssert);
                }
            }
            else {
                assert currentEvent.equals(process.sink()) :
                        "non-sink node does not have primary child: " + currentEvent;
            }

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
        BoolExpr enc = ctx.mkTrue();

        for (XEvent loadEvent : process.getNodesExceptSource(e -> e instanceof XLoadMemoryEvent)) {
            XLoadMemoryEvent load = (XLoadMemoryEvent) loadEvent;
            XSharedLvalueMemoryUnit loadLoc = load.getSource();
            Expr loadLocVar = dataFlowEncoder.encodeMemoryUnit(loadLoc, load);
            for (XEvent storeEvent : process.getNodesExceptSource(e -> e instanceof XStoreMemoryEvent)) {
                XStoreMemoryEvent store = (XStoreMemoryEvent) storeEvent;
                XSharedLvalueMemoryUnit storeLoc = store.getDestination();
                Expr storeLocVar = dataFlowEncoder.encodeMemoryUnit(storeLoc, store);
                if (loadLoc.equals(storeLoc)) {
                    BoolExpr rfRelationVar = Utils.edge("rf", store, load, ctx);
                    enc = ctx.mkAnd(enc, ctx.mkImplies(rfRelationVar, ctx.mkEq(storeLocVar, loadLocVar)));
                }
            }
            // TODO: same for process.getStoreAndInitEvents() ...
        }
        return enc;
    }
}
