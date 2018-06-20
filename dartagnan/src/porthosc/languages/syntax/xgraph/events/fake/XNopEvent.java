package porthosc.languages.syntax.xgraph.events.fake;

import porthosc.languages.syntax.xgraph.events.XEmptyEventBase;
import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;


public final class XNopEvent extends XEmptyEventBase implements XFakeEvent {

    public XNopEvent(XEventInfo info) {
        this(NOT_UNROLLED_REF_ID, info);
    }

    private XNopEvent(int refId, XEventInfo info) {
        super(refId, info, createUniqueEventId());
    }

    @Override
    public XNopEvent asNodeRef(int refId) {
        return new XNopEvent(refId, getInfo());
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return wrapWithBracketsAndDepth("nop"+getInfo().getEventId()+"()");
    }
}
