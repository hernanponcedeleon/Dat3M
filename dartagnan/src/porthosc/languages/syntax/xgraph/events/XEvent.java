package porthosc.languages.syntax.xgraph.events;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import porthosc.languages.common.graph.FlowGraphNode;
import porthosc.languages.syntax.xgraph.XEntity;
import porthosc.languages.syntax.xgraph.XProcessLocalElement;
import porthosc.languages.syntax.xgraph.process.XProcessId;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;


public interface XEvent extends FlowGraphNode, XProcessLocalElement, XEntity {

    <T> T accept(XEventVisitor<T> visitor);

    XEventInfo getInfo();

    XEvent asNodeRef(int refId);

    //TODO: old-code method, to be replaced
    default BoolExpr executes(Context ctx) {
        return ctx.mkBoolConst(repr());
    }

    default String repr() {
        return String.format("E%s", getInfo().getEventId());
    }

    default boolean isInit() {
        return getProcessId()== XProcessId.PreludeProcessId;
    }
}
