package porthosc.languages.syntax.xgraph.events;

import porthosc.languages.syntax.xgraph.process.XProcessId;

import java.util.Objects;


public abstract class XEventBase implements XEvent {

    private final int refId;
    private final XEventInfo info;

    public XEventBase(int refId, XEventInfo info) {
        this.refId = refId;
        this.info = info;
    }

    @Override
    public int getUniqueId() {
        return getInfo().getEventId();
    }

    @Override
    public int getRefId() {
        return refId;
    }

    @Override
    public XEventInfo getInfo() {
        return info;
    }

    @Override
    public String getName() {
        return "e_" + hashCode();
    }

    @Override
    public XProcessId getProcessId() {
        return getInfo().getProcessId();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XEventBase)) { return false; }
        XEventBase that = (XEventBase) o;
        return this.getRefId() == that.getRefId() &&
                this.getInfo().equals(that.getInfo());
    }

    public boolean weakEquals(XEventBase that) {
        return this.getRefId() == that.getRefId() &&
                this.getInfo().weakEquals(that.getInfo());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getRefId(), getInfo());
    }

    public int weakHashCode() {
        return Objects.hash(getRefId(), getInfo().weakHashCode());
    }

    protected String wrapWithBracketsAndDepth(String message) {
        return refId != NOT_UNROLLED_REF_ID
                ? "[" + message + ", " + getRefId() + "]"
                : message;
    }
}
