package porthosc.languages.syntax.xgraph.events.memory;

import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.memories.XLocalLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XLocalMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XSharedLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;


/**
 * Write event from local memory (registry, {@link XLocalMemoryUnit})
 * to the shared memory ({@link XLocalMemoryUnit})
 */
public final class XStoreMemoryEvent extends XMemoryEventBase implements XSharedMemoryEvent {

    public XStoreMemoryEvent(XEventInfo info, XSharedLvalueMemoryUnit destination, XLocalMemoryUnit source) {
        this(NOT_UNROLLED_REF_ID, info, destination, source);
    }

    private XStoreMemoryEvent(int nodeRef, XEventInfo info, XSharedLvalueMemoryUnit destination, XLocalMemoryUnit source) {
        super(nodeRef, info, destination, source);
    }

    @Override
    public XSharedLvalueMemoryUnit getDestination() {
        return (XSharedLvalueMemoryUnit) super.getDestination();
    }

    @Override
    public XLocalMemoryUnit getSource() {
        return (XLocalMemoryUnit) super.getSource();
    }

    @Override
    public XStoreMemoryEvent asNodeRef(int refId) {
        return new XStoreMemoryEvent(refId, getInfo(), getDestination(), getSource());
    }

    public XSharedLvalueMemoryUnit getLoc() {
        return getDestination();
    }

    @Override
    public XLocalLvalueMemoryUnit getReg() {
        XLocalMemoryUnit source = getSource();
        return source instanceof XLocalLvalueMemoryUnit
                ? (XLocalLvalueMemoryUnit) source
                : null;
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return wrapWithBracketsAndDepth("store(" + getDestination() + " <- " + getSource() + ")");
    }
}
