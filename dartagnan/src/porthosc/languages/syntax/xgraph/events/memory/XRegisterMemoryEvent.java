package porthosc.languages.syntax.xgraph.events.memory;

import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.memories.XLocalLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XLocalMemoryUnit;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;


/**
 * XEvent of writing from one local memory to another (e.g. from one register to sth).
 */
public final class XRegisterMemoryEvent extends XMemoryEventBase implements XLocalMemoryEvent {

    public XRegisterMemoryEvent(XEventInfo info, XLocalLvalueMemoryUnit destination, XLocalMemoryUnit source) {
        super(NOT_UNROLLED_REF_ID, info, destination, source);
    }

    private XRegisterMemoryEvent(int refId, XEventInfo info, XLocalLvalueMemoryUnit destination, XLocalMemoryUnit source) {
        super(refId, info, destination, source);
    }

    @Override
    public XLocalLvalueMemoryUnit getDestination() {
        return (XLocalLvalueMemoryUnit) super.getDestination();
    }

    @Override
    public XLocalMemoryUnit getSource() {
        return (XLocalMemoryUnit) super.getSource();
    }

    //@Override
    //public XLocalMemoryUnit getReg() {
    //    return getDestination(); // TODO: OR source???
    //}

    @Override
    public XRegisterMemoryEvent asNodeRef(int refId) {
        return new XRegisterMemoryEvent(refId, getInfo(), getDestination(), getSource());
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return wrapWithBracketsAndDepth(getDestination() + " <- " + getSource());
    }
}
