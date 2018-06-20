package porthosc.languages.syntax.xgraph.events.barrier;

import porthosc.languages.syntax.xgraph.events.XEmptyEventBase;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;


public final class XBarrierEvent extends XEmptyEventBase implements XFenceEvent {
    public enum Kind {
        Mfence,
        Sync,
        OptSync,
        Lwsync,
        OptLwsync,
        Ish,
        Isb,
        Isync,
        ;

        public XBarrierEvent create(XEventInfo info) {
            return new XBarrierEvent(info, this);
        }
    }

    private final Kind kind;

    XBarrierEvent(XEventInfo info, Kind kind) {
        this(NOT_UNROLLED_REF_ID, info, kind);
    }

    private XBarrierEvent(int refId, XEventInfo info, Kind kind) {
        super(refId, info, createUniqueEventId());
        this.kind = kind;
    }

    public Kind getKind() {
        return kind;
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public XEvent asNodeRef(int refId) {
        return new XBarrierEvent(refId, getInfo(), getKind());
    }
}
