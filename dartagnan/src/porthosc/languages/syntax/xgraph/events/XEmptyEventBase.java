package porthosc.languages.syntax.xgraph.events;

import java.util.Objects;


public abstract class XEmptyEventBase extends XEventBase {

    /**
     * This field serve for controlling the "equalitiness" of empty events
     */
    private final int emptyEventId;

    public XEmptyEventBase(int refId, XEventInfo info, int emptyEventId) {
        super(refId, info);
        this.emptyEventId = emptyEventId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XEmptyEventBase)) { return false; }
        if (!super.equals(o)) { return false; }
        XEmptyEventBase that = (XEmptyEventBase) o;
        return emptyEventId == that.emptyEventId;
    }

    @Override
    public String toString() {
        return "e" + hashCode();
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), emptyEventId);
    }

    private static int uniqueEventId = 1;
    protected static int createUniqueEventId() {
        return uniqueEventId++;
    }
}
