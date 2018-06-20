package porthosc.languages.syntax.xgraph.events.fake;

import porthosc.languages.syntax.xgraph.events.XEmptyEventBase;
import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.visitors.XEventVisitor;
import porthosc.utils.exceptions.NotSupportedException;


public final class XExitEvent extends XEmptyEventBase implements XFakeEvent {

    //private final boolean boundAchieved;
    private static final int EXIT_EMPTY_EVENT_ID = 0;//todo: for different sink-nodes different empty-event-ids !

    public XExitEvent(XEventInfo info) {
        super(SINK_NODE_REF_ID, info, EXIT_EMPTY_EVENT_ID);
    }

    @Override
    public XExitEvent asNodeRef(int refId) {
        throw new NotSupportedException("Exit event is a sink node and cannot be a reference");
    }

    @Override
    public <T> T accept(XEventVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public String toString() {
        return "EXIT_" + getInfo().getProcessId();
    }

    // TODO: split exit into  two types: bound-achieved / bound-not-achieved
    // todo: do not forget to set up hashcode for the splitted exit events

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XExitEvent)) { return false; }
        return this.weakEquals((XExitEvent) o);
    }

    @Override
    public int hashCode() {
        return weakHashCode();
    }
}
