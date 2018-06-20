package porthosc.languages.syntax.xgraph.events.memory;

import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.memories.XLocalLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XLocalMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XSharedLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XSharedMemoryUnit;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;


/** Load event from shared memory ({@link XLocalMemoryUnit})
 * to local storage (registry, {@link XLocalMemoryUnit}) */
public final class XLoadMemoryEvent extends XMemoryEventBase implements XSharedMemoryEvent {

    public XLoadMemoryEvent(XEventInfo info, XLocalLvalueMemoryUnit destination, XSharedMemoryUnit source) {
        this(NOT_UNROLLED_REF_ID, info, destination, source);
    }

    private XLoadMemoryEvent(int refId, XEventInfo info, XLocalLvalueMemoryUnit destination, XSharedMemoryUnit source) {
        super(refId, info, destination, source);
    }

    @Override
    public XLocalLvalueMemoryUnit getDestination() {
        return (XLocalLvalueMemoryUnit) super.getDestination();
    }

    @Override
    public XSharedLvalueMemoryUnit getSource() {
        return (XSharedLvalueMemoryUnit) super.getSource();
    }

    @Override
    public XLoadMemoryEvent asNodeRef(int refId) {
        return new XLoadMemoryEvent(refId, getInfo(), getDestination(), getSource());
    }

    public XSharedLvalueMemoryUnit getLoc() {
        return getSource();
    }

    @Override
    public XLocalLvalueMemoryUnit getReg() {
        return getDestination();
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return wrapWithBracketsAndDepth("load(" + getDestination() + " <- " + getSource() + ")");
    }
}
