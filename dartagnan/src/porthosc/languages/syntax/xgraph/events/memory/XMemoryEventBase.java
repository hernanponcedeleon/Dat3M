package porthosc.languages.syntax.xgraph.events.memory;

import porthosc.languages.syntax.xgraph.events.XEventBase;
import porthosc.languages.syntax.xgraph.events.XEventInfo;
import porthosc.languages.syntax.xgraph.memories.XMemoryUnit;

import java.util.Objects;


abstract class XMemoryEventBase extends XEventBase implements XMemoryEvent {
    private final XMemoryUnit destination;
    private final XMemoryUnit source;

    XMemoryEventBase(int refId, XEventInfo info, XMemoryUnit destination, XMemoryUnit source) {
        super(refId, info);
        this.destination = destination;
        this.source = source;
    }


    public XMemoryUnit getDestination() {
        return destination;
    }

    public XMemoryUnit getSource() {
        return source;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XMemoryEventBase)) { return false; }
        if (!super.equals(o)) { return false; }
        XMemoryEventBase that = (XMemoryEventBase) o;
        return Objects.equals(getDestination(), that.getDestination()) &&
                Objects.equals(getSource(), that.getSource());
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getDestination(), getSource());
    }
}
