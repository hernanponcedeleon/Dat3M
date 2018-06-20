package porthosc.languages.syntax.xgraph.events.controlflow;

import porthosc.languages.common.XType;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.XEventBase;
import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.memories.XLocalLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XLocalMemoryUnit;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;
import porthosc.languages.syntax.xgraph.visitors.XMemoryUnitVisitor;
import porthosc.utils.exceptions.NotImplementedException;


public class XFunctionCallEvent extends XEventBase implements XControlFlowEvent, XLocalMemoryUnit {

    private final XLocalLvalueMemoryUnit result = null;
    private final XType type = null;

    //TODO: this is a mock
    public XFunctionCallEvent(int refId, XEventInfo info) {
        super(refId, info);
    }

    @Override
    public XEvent asNodeRef(int refId) {
        throw new NotImplementedException();
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public XType getType() {
        return type;
    }

    @Override
    public <T> T accept(XMemoryUnitVisitor<T> visitor) {
        return null;
    }
}
