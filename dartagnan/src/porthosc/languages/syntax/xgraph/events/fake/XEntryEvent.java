package porthosc.languages.syntax.xgraph.events.fake;

import porthosc.languages.syntax.xgraph.events.XEmptyEventBase;
import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;
import porthosc.utils.exceptions.NotSupportedException;


public final class XEntryEvent extends XEmptyEventBase implements XFakeEvent {

    private static final int ENTRY_EMPTY_EVENT_ID = 0;

    public XEntryEvent(XEventInfo info) {
        super(SOURCE_NODE_REF_ID, info, ENTRY_EMPTY_EVENT_ID);
    }

    @Override
    public XEntryEvent asNodeRef(int refId) {
        throw new NotSupportedException("Entry event is a source node and cannot be a reference");
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return "ENTRY_" + getInfo().getProcessId();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof XEntryEvent)) return false;
        return this.weakEquals((XEntryEvent) o);
    }

    @Override
    public int hashCode() {
        return weakHashCode();
    }
}
