package porthosc.languages.syntax.xgraph.events.memory;

import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.memories.XLocalLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XRvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XSharedLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;


public final class XInitialWriteEvent extends XMemoryEventBase implements XSharedMemoryEvent {
    // implements XLocalMemoryEvent because it is not a subject for relaxations
    // TODO: rename XLocalMemoryEvent -> XNonRelaxableMemoryEvent/XStrongMemoryEvent, XSharedMemoryEvent -> XRelaxableMemoryEvent/XWeakMemoryEvent.

    // TODO: destination: XLvalue ; source: XRvalue
    public XInitialWriteEvent(XEventInfo info, XLvalueMemoryUnit destination, XRvalueMemoryUnit source) {
        this(NOT_UNROLLED_REF_ID, info, destination, source);
    }

    private XInitialWriteEvent(int refId, XEventInfo info, XLvalueMemoryUnit destination, XRvalueMemoryUnit source) {
        super(refId, info, destination, source);
    }

    @Override
    public XLvalueMemoryUnit getDestination() {
        return (XLvalueMemoryUnit) super.getDestination();
    }

    @Override
    public XRvalueMemoryUnit getSource() {
        return (XRvalueMemoryUnit) super.getSource();
    }

    @Override
    public XSharedLvalueMemoryUnit getLoc() {
        XRvalueMemoryUnit source = getSource();
        XLvalueMemoryUnit destination = getDestination();
        if (source instanceof XSharedLvalueMemoryUnit) {
            if (destination instanceof XSharedLvalueMemoryUnit) {
                throw new IllegalStateException("BOTH MEMORY UNITS ARE SHARED. WHAT TO DO?"); //TODO: find out this
            }
            return (XSharedLvalueMemoryUnit) source;
        }
        else if (destination instanceof XSharedLvalueMemoryUnit) {
            return (XSharedLvalueMemoryUnit) destination;
        }
        else {
            throw new IllegalStateException("NONE OF MEMORY UNITS ARE SHARED. WHAT TO DO?"); //TODO: find out this
        }
    }

    @Override
    public XLocalLvalueMemoryUnit getReg() {
        XRvalueMemoryUnit source = getSource();
        XLvalueMemoryUnit destination = getDestination();
        if (source instanceof XLocalLvalueMemoryUnit) {
            if (destination instanceof XLocalLvalueMemoryUnit) {
                throw new IllegalStateException("BOTH MEMORY UNITS ARE LOCAL. WHAT TO DO?"); //TODO: find out this
            }
            return (XLocalLvalueMemoryUnit) source;
        }
        else if (destination instanceof XLocalLvalueMemoryUnit) {
            return (XLocalLvalueMemoryUnit) destination;
        }
        else {
            throw new IllegalStateException("NONE OF MEMORY UNITS ARE LOCAL. WHAT TO DO?"); //TODO: find out this
        }
    }

    @Override
    public XInitialWriteEvent asNodeRef(int refId) {
        return new XInitialWriteEvent(refId, getInfo(), getDestination(), getSource());
    }

    @Override
    public String toString() {
        return wrapWithBracketsAndDepth("initial_write(" + getDestination() + "<- " + getSource() + ")");
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
